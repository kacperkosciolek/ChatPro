//
//  GroupChatViewModel.swift
//  ChatPro
//
//  Created by Kacper on 08/10/2022.
//

import Foundation
import Firebase

struct GroupChatViewModel: ChatViewModel {    
    private var group: Group
    
    var profileGroupImage: [URL]? {
        return group.profileGroupImage
    }
    var name: String {
        return group.name
    }
    var lastMessageText: String {
        guard let lastMessage = group.lastMessage else { return "" }
        let senderUsername = lastMessage.senderUsername ?? ""
        
        switch lastMessage.type {
        case .text:
            return isCurrentUser ? "You: \(lastMessage.message)" : "\(senderUsername): \(lastMessage.message)"
        case .image:
            return isCurrentUser ? "You sent a photo." : "\(senderUsername) sent a photo."
        default: return ""
        }
    }
    var setUsernameFont: UIFont {
        group.isRevealed ? UIFont.systemFont(ofSize: 18) : UIFont.boldSystemFont(ofSize: 19)
    }
    var setMessageFont: UIFont {
        group.isRevealed ? UIFont.systemFont(ofSize: 16) : UIFont.boldSystemFont(ofSize: 15)
    }
    var isCurrentUser: Bool {
        group.lastMessage?.senderUid == Auth.auth().currentUser?.uid ? true : false
    }
    init(group: Group) {
        self.group = group
    }
}


