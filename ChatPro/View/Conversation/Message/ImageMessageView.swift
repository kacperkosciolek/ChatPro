//
//  ImageMessage.swift
//  ChatPro
//
//  Created by Kacper on 02/12/2022.
//

import UIKit

class ImageMessageView: UIImageView {
    convenience init() {
        self.init(frame: .zero)
        contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        widthAnchor.constraint(equalToConstant: 74).isActive = true
        clipsToBounds = true
        layer.cornerRadius = 37
     }
}
