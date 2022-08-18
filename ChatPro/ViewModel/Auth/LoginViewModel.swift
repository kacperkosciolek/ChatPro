//
//  LoginViewModel.swift
//  ChatPro
//
//  Created by Kacper on 02/05/2022.
//

import UIKit

struct LoginViewModel: AuthViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        email?.isEmpty == false && password?.isEmpty == false
    }
    var backgroundColor: UIColor {
        formIsValid ? .blue : .systemBlue
    }
    var buttonTitleColor: UIColor {
        formIsValid ? .white : UIColor(white: 1, alpha: 0.7)
    }
}
