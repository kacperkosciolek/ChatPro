//
//  ChatViewModel.swift
//  ChatPro
//
//  Created by Kacper on 25/05/2022.
//

import Foundation
import Firebase

struct ChatViewModel {
    private var lastMessage: [String: String]
    
    var messageText: String {
        if lastMessage["message"]?.isURL == true {
            return isCurrentUser ? "You sent a photo" : "The user sent a photo."
        } else {
            return isCurrentUser ? "You: \(lastMessage["message"] ?? "")" : lastMessage["message"] ?? ""
        }
    }
    var isCurrentUser: Bool {
        if lastMessage["sender"] == Auth.auth().currentUser?.uid {
            return true
        }
        return false
    }
    init(lastMessage: [String: String]) {
        self.lastMessage = lastMessage
    }
}

