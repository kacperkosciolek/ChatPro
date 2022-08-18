//
//  Message.swift
//  ChatPro
//
//  Created by Kacper on 15/05/2022.
//

import UIKit
import Firebase

struct Message {
    var sender: String
    var timestamp: Date!
    var messageText: String?
    var image: URL?
    
    init(data: [String: Any]) {
        self.sender = data["sender"] as? String ?? ""
    
        if let timestamp = data["timestamp"] as? TimeInterval {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        if let messageText = data["messageText"] as? String {
            self.messageText = messageText
        }
        if let image = data["image"] as? String {
            guard let url = URL(string: image) else { return }
            self.image = url
        }
    }
}

