//
//  GroupMessage.swift
//  ChatPro
//
//  Created by Kacper on 28/11/2022.
//

import Foundation

class GroupMessage: Message {
    var profileImages: [URL]?
    var nickname: String?

    override init(id: String, data: [String : Any]) {
        super.init(id: id, data: data)
    }
}

