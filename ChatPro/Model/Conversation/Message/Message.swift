//
//  Message.swift
//  ChatPro
//
//  Created by Kacper on 15/05/2022.
//

import Foundation

class Message: ConversationElement {
    var id: String
    var messageType: MessageType!
    var sender: String
    var timestamp: Date!
    
    init(id: String, data: [String: Any]) {
        self.id = id
        
        if let rawValue = data["messageType"] as? Int {
            self.messageType = MessageType(rawValue: rawValue)
        }
        self.sender = data["sender"] as? String ?? ""
    
        if let timestamp = data["timestamp"] as? TimeInterval {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
