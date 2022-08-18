//
//  User.swift
//  ChatPro
//
//  Created by Kacper on 29/04/2022.
//

import UIKit

struct User {
    var uid: String
    var username: String
    var email: String
    var profileImage: URL?
    var timestamp: Date!
    var numberOfFriends: Int?
    var lastMessage: [String: String]?
    var isRevealed: Bool?
    var timestampOfRevealed: Date!
    var isMessage: Bool?
    
    init(uid: String, data: [String: Any]) {
        self.uid = uid
        self.username = data["username"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        
        if let profileImage = data["profileImage"] as? String {
            guard let url = URL(string: profileImage) else { return }
            self.profileImage = url
        }
        if let timestamp = data["timestamp"] as? TimeInterval {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        self.lastMessage = data["lastMessage"] as? [String: String] ?? ["": ""]
        self.isRevealed = data["isRevealed"] as? Bool ?? false
        
        if let timestampOfRevealed = data["timestampOfRevealed"] as? TimeInterval {
            self.timestampOfRevealed = Date(timeIntervalSince1970: timestampOfRevealed)
        }
        self.isMessage = data["isMessage"] as? Bool ?? false
    }
}

