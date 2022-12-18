//
//  NewNicknameNotification.swift
//  ChatPro
//
//  Created by Kacper on 20/11/2022.
//

import Foundation

class NewNicknameNotification: GroupNotification {
    var changed: String
    var changedFor: String
    
    override init(data: [String: Any]) {
        self.changed = data["changed"] as? String ?? ""
        self.changedFor = data["changedFor"] as? String ?? ""
        super.init(data: data)
    }
}
