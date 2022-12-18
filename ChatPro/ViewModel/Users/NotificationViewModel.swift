//
//  NotificationViewModel.swift
//  ChatPro
//
//  Created by Kacper on 21/05/2022.
//

import UIKit

struct NotificationViewModel {
    var viewModel: UserViewModel
    
    var profileImage: URL {
        return viewModel.profileImage!
    }
    var notificationAttributedText: NSAttributedString {
        let attributedText = NSMutableAttributedString(string: viewModel.username,
                                                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: " wants to be your friend.",
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        return attributedText
    }
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }
}
