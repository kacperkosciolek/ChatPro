//
//  FriendMessage.swift
//  ChatPro
//
//  Created by Kacper on 28/11/2022.
//

import Foundation

class FriendMessage: Message {
    var profileImage: URL?

    override init(id: String, data: [String : Any]) {
        super.init(id: id, data: data)
    }
}
