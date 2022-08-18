//
//  AuthViewModel.swift
//  ChatPro
//
//  Created by Kacper on 02/05/2022.
//

import UIKit

protocol AuthViewModel {
    var formIsValid: Bool { get }
    var backgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}
