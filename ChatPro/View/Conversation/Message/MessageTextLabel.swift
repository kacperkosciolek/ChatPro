//
//  MessageTextLabel.swift
//  ChatPro
//
//  Created by Kacper on 02/12/2022.
//

import UIKit

class MessageTextLabel: UILabel {
    convenience init() {
        self.init(frame: .zero)
        contentMode = .scaleToFill
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 18)
    }
}
