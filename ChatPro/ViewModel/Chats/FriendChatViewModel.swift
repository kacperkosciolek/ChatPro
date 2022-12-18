//
//  FriendChatViewModel.swift
//  ChatPro
//
//  Created by Kacper on 25/05/2022.
//

import Foundation
import Firebase

struct FriendChatViewModel: ChatViewModel {
    var friend: Friend
    
    var profileImage: URL? {
        return friend.profileImage
    }
    var username: String {
        return friend.username
    }
    var lastMessageText: String {
        guard let lastMessage = friend.lastMessage else { return "" }
    
        switch lastMessage.type {
        case .text:
            return isCurrentUser ? "You: \(lastMessage.message)" : lastMessage.message
        case .image:
            return isCurrentUser ? "You sent a photo." : "The user sent a photo."
        default: return ""
        }
    }
    var setUsernameFont: UIFont {
        friend.isRevealed ? UIFont.systemFont(ofSize: 18) : UIFont.boldSystemFont(ofSize: 19)
    }
    var setMessageFont: UIFont {
        friend.isRevealed ? UIFont.systemFont(ofSize: 16) : UIFont.boldSystemFont(ofSize: 15)
    }
    var isCurrentUser: Bool {
        friend.lastMessage?.senderUid == Auth.auth().currentUser?.uid ? true : false
    }
    init(friend: Friend) {
        self.friend = friend
    }
}

