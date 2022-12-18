//
//  CreateGroupViewModel.swift
//  ChatPro
//
//  Created by Kacper on 02/10/2022.
//

import UIKit

struct CreateGroupViewModel {
    var isUserSelected: Bool
    
    var setBackground: UIColor {
        isUserSelected ? .systemBlue : .white
    }
    
    var setImage: UIImage {
        isUserSelected ? UIImage(named: "checkmark") ?? UIImage() : UIImage()
    }
    
    init(isUserSelected: Bool) {
        self.isUserSelected = isUserSelected
    }
}
