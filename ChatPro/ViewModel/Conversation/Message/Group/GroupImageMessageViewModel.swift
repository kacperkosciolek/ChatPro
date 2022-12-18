//
//  GroupImageMessageViewModel.swift
//  ChatPro
//
//  Created by Kacper on 27/11/2022.
//

import Foundation

class GroupImageMessageViewModel: GroupMessageViewModel, ImageMessagingViewModel {
    var image: URL?

    init(message: GroupImageMessage) {
        self.image = message.image
        super.init(message: message)
    }
}
