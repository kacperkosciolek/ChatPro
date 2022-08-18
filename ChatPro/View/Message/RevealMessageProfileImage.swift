//
//  RevealMessageProfileImage.swift
//  ChatPro
//
//  Created by Kacper on 10/08/2022.
//

import UIKit
import SDWebImage

class RevealMessageProfileImage: UIImageView {
    private var profileImageView: UIImageView = {
        var view = UIImageView()
        view.isHidden = true
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
}
