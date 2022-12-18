//
//  GroupLeftImageCell.swift
//  ChatPro
//
//  Created by Kacper on 28/11/2022.
//
import UIKit

class GroupLeftImageCell: GroupImageMessageCell {
    
    var message: GroupImageMessage? {
        didSet { configure() }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        setMessagePosition(with: imageMessageView,
                           topConstant: 40,
                           leftConstant: 30,
                           bottomConstant: -20,
                           rightConstant: -150)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure() {
        guard let message = message else { return }
        
        self.viewModel = GroupImageMessageViewModel(message: message)
    }
}



