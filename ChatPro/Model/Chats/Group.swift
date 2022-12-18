//
//  Group.swift
//  ChatPro
//
//  Created by Kacper on 06/11/2022.
//

import Foundation

class Group: Chat {
    var name: String
    var members: [Member]!
    var profileGroupImage: [URL]?

    override init(id: String, data: [String: Any]) {
        self.name = data["name"] as? String ?? ""

        super.init(id: id, data: data)

        if let profileGroupImage = data["profileGroupImage"] as? [String] {
            self.profileGroupImage = profileGroupImage.compactMap { URL(string: $0) }
        }
    }
}
