//
//  Chat.swift
//  ChatPro
//
//  Created by Kacper on 09/11/2022.
//

import UIKit

class Chat {
    var id: String
    var chatType: ChatType!
    var conversationKey: String
    var timestamp: Date!
    var isRevealed: Bool
    var lastMessage: LastMessage?

    init(id: String, data: [String: Any]) {
        self.id = id
        
        if let rawValue = data["type"] as? Int {
            self.chatType = ChatType(rawValue: rawValue)
        }
        self.conversationKey = data["conversationKey"] as? String ?? ""

        if let timestamp = data["timestamp"] as? TimeInterval {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        self.isRevealed = data["isRevealed"] as? Bool ?? false
        
        if let lastMessageData = data["lastMessage"] as? [String: Any] {
            self.lastMessage = LastMessage(data: lastMessageData)
        }
    }
}
