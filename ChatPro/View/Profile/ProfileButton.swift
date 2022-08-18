//
//  ProfileSettingsButton.swift
//  ChatPro
//
//  Created by Kacper on 11/05/2022.
//

import UIKit

class ProfileButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .systemBlue.withAlphaComponent(0.8)
        setTitle(title, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 300).isActive = true
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 20
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
