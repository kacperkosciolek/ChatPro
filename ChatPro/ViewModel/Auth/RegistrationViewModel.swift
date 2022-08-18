//
//  RegistrationViewModel.swift
//  ChatPro
//
//  Created by Kacper on 01/05/2022.
//

import UIKit

struct RegistrationViewModel: AuthViewModel {
    var username: String?
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        username?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false 
    }
    var backgroundColor: UIColor {
        formIsValid ? .blue : .systemBlue
    }
    var buttonTitleColor: UIColor {
        formIsValid ? .white : UIColor(white: 1, alpha: 0.7)
    }
}
