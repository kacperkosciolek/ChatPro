//
//  FriendTextMessageViewModel.swift
//  ChatPro
//
//  Created by Kacper on 29/11/2022.
//

import Foundation

class FriendTextMessageViewModel: FriendMessageViewModel, TextMessagingViewModel {
    var text: String

    init(message: FriendTextMessage) {
        self.text = message.text
        super.init(message: message)
    }
}

