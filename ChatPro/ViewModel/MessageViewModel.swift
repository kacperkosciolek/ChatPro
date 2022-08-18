//
//  ConversationViewModel.swift
//  ChatPro
//
//  Created by Kacper on 15/05/2022.
//

import UIKit

struct MessageViewModel {
    var message: Message
    
    var image: URL? {
        return message.image
    }
    var attributedText: NSAttributedString? {
        if isURL! {
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            let underlineAttributedString = NSAttributedString(string: message.messageText ?? "", attributes: underlineAttribute)
            return underlineAttributedString
        } else {
            return NSAttributedString(string: message.messageText ?? "")
        }
    }
    var dateOfMessage: String {
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
    var isURL: Bool? {
        guard let text = message.messageText else { return false }
    
        if text.isURL { return true }
        return false
    }
    init(message: Message) {
        self.message = message
    }
}
