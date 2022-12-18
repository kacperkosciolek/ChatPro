//
//  TextMessagingViewModel.swift
//  ChatPro
//
//  Created by Kacper on 03/12/2022.
//

import UIKit

protocol TextMessagingViewModel {
    var text: String { get }
}
extension TextMessagingViewModel {
    var attributedText: NSAttributedString? {
        if text.isURL {
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            let underlineAttributedString = NSAttributedString(string: text, attributes: underlineAttribute)
            return underlineAttributedString
        } else {
            return NSAttributedString(string: text)
        }
    }
    var isURL: Bool {
        text.isURL ? true : false
    }
}
