//
//  UserManager.swift
//  ChatPro
//
//  Created by Kacper on 02/05/2022.
//

import UIKit
import Firebase

struct UserManager {    
    static func logUserIn(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    static func registerUser(username: String, email: String, password: String, profileImage: UIImage, completion: @escaping(Error?, DatabaseReference) -> Void) {
        ImageUploader.uploadImage(image: profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("\(error.localizedDescription) - Failed to register user")
                    return
                }
                guard let userID = result?.user.uid else { return }
                
                let dataOfUser: [String: Any] = [
                    "username": username,
                    "email": email,
                    "profileImage": imageUrl
                ]
                USERS.child(userID).updateChildValues(dataOfUser) { err, ref in
                    completion(err, ref)
                }
            }
        }
    }
    static func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dataOfUser = snapshot.value as? [String: Any] else { return }
   
            let user = User(uid: uid, data: dataOfUser)
            completion(user)
        }
    }
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        USERS.observe(.childAdded) { snapshot in
            let userID = snapshot.key
            
            guard let data = snapshot.value as? [String: Any] else { return }
            
            let user = User(uid: userID, data: data)
            users.append(user)
            completion(users)
        }
    }
    static func sendRequest(uid: String, success: @escaping() -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REQUESTS.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() { return }
            else {
                REQUESTS.child(uid).updateChildValues([currentUid : 1])
                success()
            }
        }
    }
    static func checkRequests(completion: @escaping(User) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REQUESTS.child(currentUid).observe(.childAdded) { snapshot in
            self.fetchUser(uid: snapshot.key) { user in completion(user) }
        }
    }
    static func removeRequest(uid: String) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REQUESTS.child(currentUid).child(uid).removeValue()
    }
    static func addFriend(uid: String) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            
            self.fetchValues(forUid: uid, data: data) { values in
                USERS.child(currentUid).child("friends").child(uid).updateChildValues(values)
            }
        }
        USERS.child(currentUid).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            
            self.fetchValues(forUid: currentUid, data: data) { values in
                USERS.child(uid).child("friends").child(currentUid).updateChildValues(values)
            }
        }
    }
    static func fetchFriends(completion: @escaping([User]) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }

        var friends = [User]()

        USERS.child(currentUser).child("friends").observe(.childAdded) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }

            let friend = User(uid: snapshot.key, data: data)
            friends.append(friend)
            completion(friends)
        }
    }
    static func fetchNumberOfFriends(forUid: String, completion: @escaping(Int) -> Void) {
        USERS.child(forUid).child("friends").observeSingleEvent(of: .value) { snapshot in
            let numberOfFriends = snapshot.children.allObjects.count
            
            completion(numberOfFriends)
        }
    }
    static func checkIfUserIsFriend(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
   
        USERS.child(currentUser).child("friends").child(uid).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() { completion(true) }
            else { completion(false) }
        }
        //        USERS.child(currentUser).child("friends").observeSingleEvent(of: .value) { snapshot in
        //            guard let data = snapshot.value as? [String: Any] else { return }
        //
        //            if data.keys.contains(uid) { completion(true) }
        //            else { completion(false) }
        //        }
    }
    static func observeChatChanges(completion: @escaping(User) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        USERS.child(currentUser).child("friends").observe(.childChanged) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
    
            let user = User(uid: snapshot.key, data: data)
            completion(user)
        }
    }
    static func observeTimestampChanges(forUid uid: String, completion: @escaping(TimeInterval) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        USERS.child(uid).child("friends").child(currentUser).child("timestampOfRevealed").observe(.value) { snapshot in
            guard let timestampOfRevealed = snapshot.value as? TimeInterval else { return }
            completion(timestampOfRevealed)
        }
    }
    static func stateForTheConversation(friendUid: String, isOpen: Bool) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
    
        USERS.child(currentUser).child("friends").child(friendUid).updateChildValues(["isConversationOpen": isOpen])
    }
    fileprivate static func fetchValues(
        forUid uid: String,
        data: [String: Any],
        completion: @escaping([String: Any]) -> Void) {
            
        guard let username = data["username"] as? String else { return }
        guard let profileImage = data["profileImage"] as? String else { return }
        
        let values: [String: Any] = [
            "uid": uid,
            "username": username,
            "profileImage": profileImage,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "isConversationOpen": false,
            "timestampOfRevealed": TimeInterval(0)
        ]
        completion(values)
    }
}

