//
//  ChatsManager.swift
//  ChatPro
//
//  Created by Kacper on 15/05/2022.
//

import Foundation
import Firebase

struct GroupData {
    let groupId: String
    let conversationKey: String
    let memberUid: String
    var usersToPresent: Array<User>.SubSequence
}
struct ChatsManager {
    static let shared = ChatsManager()
    
    func createFriendChat(with user: User) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let conversationKey = CONVERSATION.childByAutoId().key else { return }
        
        USERS.child(user.uid).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            
            self.fetchFriendValues(forUid: user.uid, conversationKey: conversationKey, data: data) { values in
                USERS.child(currentUid).child(CHATS).child(user.uid).updateChildValues(values)
            }
        }
        USERS.child(currentUid).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            
            self.fetchFriendValues(forUid: currentUid, conversationKey: conversationKey, data: data) { values in
                USERS.child(user.uid).child(CHATS).child(currentUid).updateChildValues(values)
            }
        }
    }
    func createGroupChat(with selectedUsers: [User]) {
        guard let groupId = USERS.childByAutoId().key else { return }
        guard let conversationKey = CONVERSATION.childByAutoId().key else { return }
        
        selectedUsers.forEach { selectedUser in
            var users = selectedUsers
            
            uploadMemberData(groupId: groupId, newMember: selectedUser)
            
            var data = GroupData(groupId: groupId,
                                conversationKey: conversationKey,
                                memberUid: selectedUser.uid,
                                usersToPresent: users[...1])
            
            if selectedUser.uid != users[0].uid && selectedUser.uid != users[1].uid {
                uploadGroupData(with: data)
            } else if selectedUser.uid == selectedUsers[1].uid {
                users.remove(at: 1)
                data.usersToPresent = users[...1]
                uploadGroupData(with: data)
            } else {
                users.remove(at: 0)
                data.usersToPresent = users[...1]
                uploadGroupData(with: data)
            }
        }
    }
    func fetchChat(with id: String, completion: @escaping(Chat) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        USERS.child(currentUser).child(CHATS).child(id).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            guard let type = data["type"] as? Int else { return }
            let chatId = snapshot.key
       
            switch type {
            case ChatType.friend.rawValue: completion(Friend(id: chatId, data: data))
            case ChatType.group.rawValue: completion(Group(id: chatId, data: data))
            default: break
            }
        }
    }
    func fetchChats(completion: @escaping([Chat]) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        var chats = [Chat]()
        
        USERS.child(currentUser).child(CHATS).observe(.childAdded) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            guard let type = data["type"] as? Int else { return }
            let chatId = snapshot.key
            
            switch type {
            case ChatType.friend.rawValue:
                let friend = Friend(id: chatId, data: data)
                chats.append(friend)
            case ChatType.group.rawValue:
                let group = Group(id: chatId, data: data)
                chats.append(group)
            default: break
            }
            completion(chats)
        }
    }
    func observeChatsChanges(completion: @escaping() -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        USERS.child(currentUser).child(CHATS).observe(.childChanged) { _ in completion() }
    }
    func removeObservers() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        USERS.child(currentUser).child(CHATS).removeAllObservers()
    }
    func setChatAsRevealed(forChat chat: Chat) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        USERS.child(currentUser).child(CHATS).child(chat.id).updateChildValues(["isRevealed": true])
        
        guard let lastMessageId = chat.lastMessage?.id else { return }
        
        switch chat.chatType {
        case .friend:
            USERS.child(currentUser).child(CHATS).child(chat.id).updateChildValues(["readMessage": lastMessageId])
        case .group:            
            GROUP_MEMBERS.child(chat.id).child(currentUser).updateChildValues([
                "readMessage": lastMessageId,
                "timestampOfRevealed": Int(NSDate().timeIntervalSince1970)])
        default: break
        }
    }
    func addNewMember(group: Group, newMember: User) {
        guard let members = group.members else { return }
        var usersToPresent = Array<User>.SubSequence()
        
        uploadMemberData(groupId: group.id, newMember: newMember)
        
        members[...1].forEach { member in
            UserManager.fetchUser(uid: member.uid) { userToPresent in
                usersToPresent.append(userToPresent)
                
                uploadGroupData(with: GroupData(groupId: group.id,
                                                conversationKey: group.conversationKey,
                                                memberUid: newMember.uid,
                                                usersToPresent: usersToPresent))
            }
        }
    }
    func updateFriendsData(chatId: String, data: MessageData) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        USERS.child(chatId).child(CHATS).child(currentUid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let isOpen = dictionary["isConversationOpen"] as? Bool else { return }

            var values = [
                "lastMessage": ["id": data.messageId,
                                "type": data.messageType,
                                "senderUid": currentUid,
                                "message": data.message],
                "timestamp": data.timestamp,
                "isRevealed": isOpen,
            ] as [String : Any]

            if !isOpen {
                USERS.child(chatId).child(CHATS).child(currentUid).updateChildValues(values)
            } else {
                values["readMessage"] = data.messageId
                USERS.child(chatId).child(CHATS).child(currentUid).updateChildValues(values)
            }
            values["isRevealed"] = true
            values["readMessage"] = data.messageId
            USERS.child(currentUid).child(CHATS).child(chatId).updateChildValues(values)
        }
    }
    func updateMembersData(chatId: String, data: MessageData, members: [Member]) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        members.forEach { member in
            GROUP_MEMBERS.child(chatId).child(member.uid).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let isOpen = dictionary["isConversationOpen"] as? Bool else { return }

                var values = [
                    "timestamp": data.timestamp,
                    "isRevealed": isOpen
                ] as [String : Any]
                
                ConversationManager.shared.fetchCurrentMember(groupId: chatId) { sender in
                    values["lastMessage"] = ["id": data.messageId,
                                             "type": data.messageType,
                                             "senderUid": sender.uid,
                                             "senderUsername": sender.nickname,
                                             "message": data.message]

                    USERS.child(member.uid).child(CHATS).child(chatId).updateChildValues(values)
                    values["isRevealed"] = true
                    USERS.child(currentUid).child(CHATS).child(chatId).updateChildValues(values)
                }
                if isOpen {
                    GROUP_MEMBERS.child(chatId).child(member.uid).updateChildValues(["readMessage": data.messageId,
                                                                                     "timestampOfRevealed": Int(NSDate().timeIntervalSince1970)])
                } else { return }
            }
        }
    }
    private func fetchFriendValues(
        forUid uid: String,
        conversationKey: String,
        data: [String: Any],
        completion: @escaping([String: Any]) -> Void) {
            
        guard let username = data["username"] as? String else { return }
        guard let profileImage = data["profileImage"] as? String else { return }
        
        let values: [String: Any] = [
            "uid": uid,
            "type": ChatType.friend.rawValue,
            "username": username,
            "profileImage": profileImage,
            "timestamp": Int(NSDate().timeIntervalSince1970),
            "isConversationOpen": false,
            "isRevealed": false,
            "conversationKey": conversationKey
        ]
        completion(values)
    }
    private func uploadGroupData(with data: GroupData) {
        var groupValues: [String: Any] = ["type": ChatType.group.rawValue,
                                          "timestamp": Int(NSDate().timeIntervalSince1970),
                                          "conversationKey": data.conversationKey,
                                          "isRevealed": false]
            
        var profileGroupImage: [String] = []
        
        let name = data.usersToPresent.map {
            String($0.username)
        }.joined(separator: ", ")
        
        data.usersToPresent.forEach {
            profileGroupImage.append($0.profileImage?.absoluteString ?? "")
        }
        
        groupValues["profileGroupImage"] = profileGroupImage
        groupValues["name"] = name
        
        USERS.child(data.memberUid).child(CHATS).child(data.groupId).updateChildValues(groupValues)
    }
    private func uploadMemberData(groupId: String, newMember: User) {
        let values: [String: Any] = [
            "timestampOfRevealed": TimeInterval(0),
            "nickname": newMember.username,
            "profileImage": newMember.profileImage?.absoluteString,
            "isConversationOpen": false
        ]
        GROUP_MEMBERS.child(groupId).child(newMember.uid).updateChildValues(values)
    }
}
