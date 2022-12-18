//
//  Constants.swift
//  ChatPro
//
//  Created by Kacper on 02/05/2022.
//

import Firebase

let DATABASE_REF = Database.database().reference()
let USERS = DATABASE_REF.child("users")
let REQUESTS = DATABASE_REF.child("requests")
let CONVERSATION = DATABASE_REF.child("conversation")
let GROUP_MEMBERS = DATABASE_REF.child("group_members")
let CHATS = "chats"


