//
//  FriendTextMessage.swift
//  ChatPro
//
//  Created by Kacper on 28/11/2022.
//

import Foundation

class FriendTextMessage: FriendMessage, TextMessaging {
    var text: String
    
    override init(id: String, data: [String : Any]) {
        self.text = data["text"] as? String ?? ""
        super.init(id: id, data: data)
    }
}
