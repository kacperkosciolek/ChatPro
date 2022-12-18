//
//  GroupNotification.swift
//  ChatPro
//
//  Created by Kacper on 20/11/2022.
//

import Foundation

class GroupNotification: ConversationElement {
    var type: GroupNotificationType!
    var timestamp: Date!
    
    init(data: [String: Any]) {
        if let rawValue = data["notificationType"] as? Int {
            self.type = GroupNotificationType(rawValue: rawValue)
        }
        if let timestamp = data["timestamp"] as? TimeInterval {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
    var notificationType: GroupNotificationType {
        self.type
    }
}
