//
//  Member.swift
//  ChatPro
//
//  Created by Kacper on 31/10/2022.
//

import Foundation

struct Member {
    var uid: String
    var nickname: String
    var profileImage: URL?
    var readMessage: String?
    var timestampOfRevealed: Date!
    
    init(uid: String, data: [String: Any]) {
        self.uid = uid
        self.nickname = data["nickname"] as? String ?? ""

        if let profileImage = data["profileImage"] as? String {
            guard let url = URL(string: profileImage) else { return }
            self.profileImage = url
        }
        self.readMessage = data["readMessage"] as? String ?? ""
        
        if let timestampOfRevealed = data["timestampOfRevealed"] as? TimeInterval {
            self.timestampOfRevealed = Date(timeIntervalSince1970: timestampOfRevealed)
        }
    }
}
