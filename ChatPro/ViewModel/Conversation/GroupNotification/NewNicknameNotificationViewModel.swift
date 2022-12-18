//
//  NewNicknameNotificationViewModel.swift
//  ChatPro
//
//  Created by Kacper on 25/11/2022.
//

import Foundation

struct NewNicknameNotificationViewModel {
    private var notification: NewNicknameNotification
    
    var notificationText: String {
        "\(notification.changed) has been changed for \(notification.changedFor)."
    }
    init(notification: NewNicknameNotification) {
        self.notification = notification
    }
}
