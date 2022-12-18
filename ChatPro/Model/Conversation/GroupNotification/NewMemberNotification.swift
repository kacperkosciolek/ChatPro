//
//  NewMemberNotification.swift
//  ChatPro
//
//  Created by Kacper on 20/11/2022.
//

import Foundation

class NewMemberNotification: GroupNotification {
    var added: String
    var addedBy: String

    override init(data: [String: Any]) {
        self.added = data["added"] as? String ?? ""
        self.addedBy = data["addedBy"] as? String ?? ""
        super.init(data: data)
    }
}


