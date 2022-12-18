//
//  User.swift
//  ChatPro
//
//  Created by Kacper on 29/04/2022.
//

import Foundation

struct User {
    var uid: String
    var username: String
    var email: String
    var profileImage: URL?
    
    init(uid: String, data: [String: Any]) {
        self.uid = uid
        self.username = data["username"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        
        if let profileImage = data["profileImage"] as? String {
            guard let url = URL(string: profileImage) else { return }
            self.profileImage = url
        }
    }
}
