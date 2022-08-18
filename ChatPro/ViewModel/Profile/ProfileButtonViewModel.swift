//
//  ProfileContentViewModel.swift
//  ChatPro
//
//  Created by Kacper on 14/05/2022.
//

import Foundation

struct ProfileButtonViewModel {
    let userIsFriend: Bool

    var titleOfButton: String {
        if userIsFriend { return "Send Message" }
        return "Add Friend"
    }

    init(userIsFriend: Bool) {
        self.userIsFriend = userIsFriend
    }
}
