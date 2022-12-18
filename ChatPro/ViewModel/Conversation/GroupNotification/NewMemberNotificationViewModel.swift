//
//  NewMemberNotificationViewModel.swift
//  ChatPro
//
//  Created by Kacper on 25/11/2022.
//

import Foundation

struct NewMemberNotificationViewModel {
    private var notification: NewMemberNotification
    
    var notificationText: String {
        "\(notification.added) has been added by \(notification.addedBy)."
    }
    init(notification: NewMemberNotification) {
        self.notification = notification
    }
}
