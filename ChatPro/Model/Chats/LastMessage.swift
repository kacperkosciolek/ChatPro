//
//  Chat.swift
//  ChatPro
//
//  Created by Kacper on 19/10/2022.
//

import Foundation

struct LastMessage {
    var id: String
    var type: MessageType!
    var senderUid: String
    var message: String
    var senderUsername: String?
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        
        if let rawValue = data["type"] as? Int {
            self.type = MessageType(rawValue: rawValue)
        }
        self.senderUid = data["senderUid"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.senderUsername = data["senderUsername"] as? String ?? ""
    }
}
