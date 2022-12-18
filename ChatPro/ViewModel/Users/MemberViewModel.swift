//
//  MemberViewModel.swift
//  ChatPro
//
//  Created by Kacper on 04/11/2022.
//

import Foundation

struct MemberViewModel {
    var member: Member
    
    var profileImage: URL? {
        member.profileImage
    }
    var nickname: String {
        member.nickname
    }
    var setANickname: String {
        "Set a nickname"
    }
    init(member: Member) {
        self.member = member
    }
}
