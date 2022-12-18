//
//  ConversationController.swift
//  ChatPro
//
//  Created by Kacper on 05/12/2022.
//

import Foundation

protocol ConversationController {
    func configureTableView()
    func configureUI()
    func loadConversation()
    func appMovedToBackground()
    func appMovedToForeground()
}
