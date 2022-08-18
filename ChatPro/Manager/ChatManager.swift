//
//  ChatManager.swift
//  ChatPro
//
//  Created by Kacper on 15/05/2022.
//

import Foundation
import Firebase

struct LastMessageData {
    let toUid: String
    let sender: String
    let message: String
    let timestamp: TimeInterval
}
struct ChatManager {
    static func uploadMessage(toUid: String, sender: String, messageText: String?, image: UIImage?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        var values = ["sender": currentUid] as [String : Any]
        
        if let image = image {
            ImageUploader.uploadImage(image: image) { imageUrl in
                values["image"] = imageUrl
                values["timestamp"] = Int(NSDate().timeIntervalSince1970)
                uploadData(toUid: toUid, values: values)
                
                uploadLastMessage(withData: LastMessageData(toUid: toUid,
                                                            sender: sender,
                                                            message: imageUrl,
                                                            timestamp: TimeInterval(Int(NSDate().timeIntervalSince1970))))
            }
        } else {
            values["messageText"] = messageText
            values["timestamp"] = Int(NSDate().timeIntervalSince1970)
            uploadData(toUid: toUid, values: values)
            
            uploadLastMessage(withData: LastMessageData(toUid: toUid,
                                                        sender: sender,
                                                        message: messageText!,
                                                        timestamp: TimeInterval(Int(NSDate().timeIntervalSince1970))))
        }
    }
    static func fetchMessages(fromUid: String, completion: @escaping([Message]) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        var messages = [Message]()
        
        CONVERSATION.child(currentUser).child(fromUid).observe(.childAdded) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            
            let message = Message(data: data)
            messages.append(message)
            completion(messages)
        }
        CONVERSATION.child(fromUid).child(currentUser).observe(.childAdded) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            
            let message = Message(data: data)
            messages.append(message)
            completion(messages)
        }
    }
    static func setConversationAsRevealed(forUser user: User) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        USERS.child(currentUser).child("friends").child(user.uid).updateChildValues(["isRevealed": true, "isMessage": false])
        
        if user.lastMessage != ["": ""] {
            USERS.child(user.uid).child("friends").child(currentUser).observeSingleEvent(of: .value) { snapshot in
                guard let data = snapshot.value as? [String: Any] else { return }
                guard let timestampOfRevealedMessage = data["timestamp"] as? TimeInterval else { return }
                  
                USERS.child(currentUser).child("friends").child(user.uid).updateChildValues(["timestampOfRevealed": timestampOfRevealedMessage])
            }
        }
    }
    fileprivate static func uploadData(toUid: String, values: [String: Any]) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        CONVERSATION.child(toUid).child(currentUser).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                CONVERSATION.child(toUid).child(currentUser).childByAutoId().updateChildValues(values)
            } else {
                CONVERSATION.child(currentUser).child(toUid).childByAutoId().updateChildValues(values)
            }
        }
    }
    fileprivate static func uploadLastMessage(withData data: LastMessageData) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USERS.child(data.toUid).child("friends").child(currentUid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let isOpen = dictionary["isConversationOpen"] as? Bool else { return }
            
            var values = [
                "lastMessage": ["sender": data.sender, "message": data.message],
                "timestamp": data.timestamp,
                "isRevealed": isOpen,
                "isMessage": true
            ] as [String : Any]
            
            if !isOpen {
                USERS.child(data.toUid).child("friends").child(currentUid).updateChildValues(values)
            } else {
                values["timestampOfRevealed"] = data.timestamp
                USERS.child(data.toUid).child("friends").child(currentUid).updateChildValues(values)
            }
            values["isRevealed"] = true
            values["timestampOfRevealed"] = data.timestamp
            USERS.child(currentUid).child("friends").child(data.toUid).updateChildValues(values)
        }
    }
}

