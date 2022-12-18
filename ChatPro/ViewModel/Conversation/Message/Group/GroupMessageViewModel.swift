//
//  GroupMessageViewModel.swift
//  ChatPro
//
//  Created by Kacper on 29/11/2022.
//

import Foundation

class GroupMessageViewModel: MessageViewModel {
    private var message: GroupMessage
    
    var nickname: String? {
        message.nickname
    }
    var profileImages: [URL]? {
        message.profileImages
    }
    init(message: GroupMessage) {
        self.message = message
        super.init(message: message)
    }
}

