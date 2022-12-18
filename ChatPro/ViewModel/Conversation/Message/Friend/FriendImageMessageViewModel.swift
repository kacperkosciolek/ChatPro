//
//  FriendImageMessageViewModel.swift
//  ChatPro
//
//  Created by Kacper on 29/11/2022.
//

import Foundation

class FriendImageMessageViewModel: FriendMessageViewModel, ImageMessagingViewModel {
    var image: URL?

    init(message: FriendImageMessage) {
        self.image = message.image
        super.init(message: message)
    }
}
