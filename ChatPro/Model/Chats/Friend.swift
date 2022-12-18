//
//  Friend.swift
//  ChatPro
//
//  Created by Kacper on 06/11/2022.
//

import Foundation

class Friend: Chat {
    var username: String
    var profileImage: URL?
    var readMessage: String?

    override init(id: String, data: [String: Any]) {
        self.username = data["username"] as? String ?? ""

        super.init(id: id, data: data)

        if let profileImage = data["profileImage"] as? String {
            guard let url = URL(string: profileImage) else { return }
            self.profileImage = url
        }
        self.readMessage = data["readMessage"] as? String ?? ""

    }
}

