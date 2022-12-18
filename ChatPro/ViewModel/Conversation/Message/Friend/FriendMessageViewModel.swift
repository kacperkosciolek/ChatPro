//
//  FriendMessageViewModel.swift
//  ChatPro
//
//  Created by Kacper on 29/11/2022.
//

import Foundation

class FriendMessageViewModel: MessageViewModel {
    private var message: FriendMessage
    
    var profileImage: URL? {
        message.profileImage
    }
    init(message: FriendMessage) {
        self.message = message
        super.init(message: message)
    }
}
