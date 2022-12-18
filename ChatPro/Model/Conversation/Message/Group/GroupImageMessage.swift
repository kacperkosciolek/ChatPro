//
//  GroupImageMessage.swift
//  ChatPro
//
//  Created by Kacper on 28/11/2022.
//

import Foundation

class GroupImageMessage: GroupMessage, ImageMessaging {
    var image: URL?

    override init(id: String, data: [String : Any]) {
        super.init(id: id, data: data)

        if let image = data["image"] as? String {
            guard let url = URL(string: image) else { return }
            self.image = url
        }
    }
}
