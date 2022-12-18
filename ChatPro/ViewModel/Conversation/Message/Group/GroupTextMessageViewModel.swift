//
//  GroupTextMessageViewModel.swift
//  ChatPro
//
//  Created by Kacper on 27/11/2022.
//

import Foundation

class GroupTextMessageViewModel: GroupMessageViewModel, TextMessagingViewModel {
    var text: String
    
    init(message: GroupTextMessage) {
        self.text = message.text
        super.init(message: message)
    }
}
