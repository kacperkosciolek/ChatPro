//
//  UserViewModel.swift
//  ChatPro
//
//  Created by Kacper on 30/05/2022.
//

import UIKit

struct UserViewModel {
    var user: User
    
    var profileImage: URL? {
        return user.profileImage
    }
    var username: String {
        return user.username
    }
    init(user: User) {
        self.user = user
    }
}
