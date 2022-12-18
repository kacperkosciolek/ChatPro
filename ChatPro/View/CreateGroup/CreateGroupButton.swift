//
//  CreateGroupButton.swift
//  ChatPro
//
//  Created by Kacper on 04/12/2022.
//

import UIKit

class CreateGroupButton: UIButton {
    init(title: String, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        setTitle(title, for: .normal)
        backgroundColor = UIColor.systemBlue
        layer.cornerRadius = 16
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        contentEdgeInsets = UIEdgeInsets(top: 5,left: 8,bottom: 5,right: 8)
        layer.masksToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

