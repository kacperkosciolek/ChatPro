//
//  TextField.swift
//  ChatPro
//
//  Created by Kacper on 25/04/2022.
//

import UIKit

class AuthTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        spacer.widthAnchor.constraint(equalToConstant: 11).isActive = true
        leftView = spacer
        leftViewMode = .always
        layer.cornerRadius = 10
        borderStyle = .none
        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.4)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 10.0, alpha: 0.8)])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
