//
//  ChatViewModel.swift
//  ChatPro
//
//  Created by Kacper on 20/11/2022.
//

import UIKit
import Firebase

protocol ChatViewModel {
    var lastMessageText: String { get }
    var setUsernameFont: UIFont { get }
    var setMessageFont: UIFont { get }
    var isCurrentUser: Bool { get }
}
