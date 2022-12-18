//
//  ConversationManager.swift
//  ChatPro
//
//  Created by Kacper on 09/11/2022.
//

import Foundation
import Firebase

struct MessageData {
    let messageId: String
    let message: String
    let messageType: Int
    let timestamp: TimeInterval
}
struct ConversationManager {
    static let shared = ConversationManager()
    
    func uploadFriendMessage(friend: Friend, config: MessageConfiguration) {
        uploadMessage(chat: friend, config: config) { data in
            ChatsManager.shared.updateFriendsData(chatId: friend.id, data: data)
        }
    }
    func uploadGroupMessage(group: Group, config: MessageConfiguration) {
        uploadMessage(chat: group, config: config) { data in
            var members = group.members!
            
            self.fetchCurrentMember(groupId: group.id) { currentMember in
                members.append(currentMember)
                ChatsManager.shared.updateMembersData(chatId: group.id,
                                                      data: data,
                                                      members: members)
            }
        }
    }
    func uploadMessage(chat: Chat, config: MessageConfiguration, completion: @escaping(MessageData) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let messageId = CONVERSATION.child(chat.conversationKey).childByAutoId().key else { return }
        let messageTimestamp = TimeInterval(Int(NSDate().timeIntervalSince1970))
        
        var values = ["sender": currentUid,
                      "infoType": ConversationElementType.message.rawValue,
                      "chatType": chat.chatType.rawValue,
                      "timestamp": messageTimestamp] as [String : Any]

        if case .text(let text) = config {
            values["text"] = text
            values["messageType"] = MessageType.text.rawValue
    
            CONVERSATION.child(chat.conversationKey).child(messageId).updateChildValues(values)

            let data = MessageData(messageId: messageId,
                                   message: text,
                                   messageType: MessageType.text.rawValue,
                                   timestamp: messageTimestamp)
            completion(data)
        }
        if case .image(let image) = config {
            ImageUploader.uploadImage(image: image) { imageUrl in
                values["image"] = imageUrl
                values["messageType"] = MessageType.image.rawValue
     
                CONVERSATION.child(chat.conversationKey).child(messageId).updateChildValues(values)

                let data = MessageData(messageId: messageId,
                                       message: imageUrl,
                                       messageType: MessageType.image.rawValue,
                                       timestamp: messageTimestamp)
                completion(data)
            }
        }
    }
    func uploadNewMemberNotification(key: String, member: String, newMember: String, completion: @escaping() -> Void) {
        let values: [String: Any] = ["infoType": ConversationElementType.notification.rawValue,
                                     "notificationType": GroupNotificationType.added.rawValue,
                                     "added": newMember,
                                     "addedBy": member,
                                     "timestamp": Int(NSDate().timeIntervalSince1970)]
        CONVERSATION.child(key).childByAutoId().updateChildValues(values)
        completion()
    }
    func uploadNewNicknameNotification(key: String, newNickname: String, oldNickname: String, completion: @escaping() -> Void) {
        let values: [String: Any] = ["infoType": ConversationElementType.notification.rawValue,
                                     "notificationType": GroupNotificationType.changed.rawValue,
                                     "changed": oldNickname,
                                     "changedFor": newNickname,
                                     "timestamp": Int(NSDate().timeIntervalSince1970)]
        CONVERSATION.child(key).childByAutoId().updateChildValues(values)
        completion()
    }
    func loadFriendConversation(with key: String, completion: @escaping([Message]) -> Void) {
        var conversation = [Message]()
        
        CONVERSATION.child(key).observe(.childAdded) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            guard let type = data["messageType"] as? Int else { return }
            let messageId = snapshot.key
            
            if MessageType.text.rawValue == type {
                conversation.append(FriendTextMessage(id: messageId, data: data))
            } else {
                conversation.append(FriendImageMessage(id: messageId, data: data))
            }
            completion(conversation)
        }
    }
    func loadGroupConversation(with key: String, completion: @escaping([ConversationElement]) -> Void) {
        var conversation = [ConversationElement]()
        
        CONVERSATION.child(key).observe(.childAdded) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            guard let type = data["infoType"] as? Int else { return }
            
            if type == ConversationElementType.message.rawValue {
                guard let type = data["messageType"] as? Int else { return }
                let messageId = snapshot.key
                
                if MessageType.text.rawValue == type {
                    conversation.append(GroupTextMessage(id: messageId, data: data))
                } else {
                    conversation.append(GroupImageMessage(id: messageId, data: data))
                }
            } else {
                guard let type = data["notificationType"] as? Int else { return }
                
                if GroupNotificationType.added.rawValue == type {
                    conversation.append(NewMemberNotification(data: data))
                } else {
                    conversation.append(NewNicknameNotification(data: data))
                }
            }
            completion(conversation)
        }
    }
    func fetchCurrentMember(groupId: String, completion: @escaping(Member) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        GROUP_MEMBERS.child(groupId).child(currentUid).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            completion(Member(uid: snapshot.key, data: data))
        }
    }
    func fetchMembers(groupId: String, completion: @escaping([Member]) -> Void) {
        var members = [Member]()
        
        GROUP_MEMBERS.child(groupId).observe(.childAdded) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }
            
            let member = Member(uid: snapshot.key, data: data)
            members.append(member)
            completion(members)
        }
    }

    func changeMemberNickname(groupId: String, memberId: String, newNickname: String, completion: @escaping() -> Void) {
        GROUP_MEMBERS.child(groupId).child(memberId).child("nickname").setValue(newNickname)
        completion()
    }
    func observeFriendReadMessage(friendId: String, completion: @escaping(String) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        USERS.child(friendId).child(CHATS).child(currentUser).child("readMessage").observe(.value) { snapshot in
            guard let readMessageId = snapshot.value as? String else { return }
            completion(readMessageId)
        }
    }
    func observeMembersChanges(groupId: String, completion: @escaping() -> Void) {
        GROUP_MEMBERS.child(groupId).observe(.childChanged) { snapshot in
            if snapshot.key == Auth.auth().currentUser?.uid { return }
            
            completion()
        }
    }
    func setConversationStatus(isOpen: Bool, chat: Chat) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        switch chat.chatType {
        case .friend:
            USERS.child(currentUser).child(CHATS).child(chat.id).updateChildValues(["isConversationOpen": isOpen])
        case .group:
            GROUP_MEMBERS.child(chat.id).child(currentUser).updateChildValues(["isConversationOpen": isOpen])
        default: break
        }
    }
    func removeObservers(chat: Chat) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        CONVERSATION.child(chat.conversationKey).removeAllObservers()
        
        switch chat.chatType {
        case .friend:
            USERS.child(chat.id).child(CHATS).child(currentUser).child("readMessage").removeAllObservers()
        case .group:
            GROUP_MEMBERS.child(chat.id).removeAllObservers()
        default: break
        }
    }
}

