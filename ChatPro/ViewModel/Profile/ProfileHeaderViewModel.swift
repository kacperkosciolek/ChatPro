//
//  ProfileHeaderViewModel.swift
//  ChatPro
//
//  Created by Kacper on 14/05/2022.
//

import Foundation
import UIKit

struct ProfileHeaderViewModel {
    var user: User
    var numberOfFriends: Int
    
    var username: String? {
        return user.username
    }
    var profileImage: URL? {
        return user.profileImage
    }
    var friends: Int? {
        return numberOfFriends
    }
    init(user: User, numberOfFriends: Int) {
        self.user = user
        self.numberOfFriends = numberOfFriends
    }
}

