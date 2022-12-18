//
//  MessageViewModel.swift
//  ChatPro
//
//  Created by Kacper on 15/05/2022.
//

import Foundation

class MessageViewModel {
    private var message: Message
    
    var messageDate: String {
        let date = DateFormatter()
        date.dateFormat = "YY/MM/dd"

        let currentDate = Date()

        if date.string(from: message.timestamp) < date.string(from: currentDate) {
            return date.string(from: message.timestamp)
        } else {
            date.dateFormat = "HH:mm"
            return date.string(from: message.timestamp)
        }
    }
    init(message: Message) {
        self.message = message
    }
}

