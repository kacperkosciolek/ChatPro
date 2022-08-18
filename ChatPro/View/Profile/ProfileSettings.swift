//
//  ProfileSettings.swift
//  ChatPro
//
//  Created by Kacper on 06/05/2022.
//

import UIKit

protocol LogoutDelegate: AnyObject {
    func logout()
}
class ProfileSettings: UIView {
    private var accountButton = ProfileButton(title: "Account")
    private var notificationButton = ProfileButton(title: "Notification")
    private var saveButton = ProfileButton(title: "Save")
    private var logoutButton = ProfileButton(title: "Log Out")
    
    private var notificationSwitch = UISwitch(frame: CGRect(x: 150, y: 300, width: 0, height: 0))
    
    weak var delegate: LogoutDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        saveButton.backgroundColor = .systemBlue
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        logoutButton.backgroundColor = .red.withAlphaComponent(0.8)
        
        let stack = UIStackView(arrangedSubviews: [accountButton, notificationButton, saveButton, logoutButton])
        stack.setCustomSpacing(23, after: saveButton)
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(notificationSwitch)
        notificationSwitch.isOn = true
        notificationSwitch.translatesAutoresizingMaskIntoConstraints = false
        notificationSwitch.addTarget(self, action: #selector(notificationButtonSwitched), for: .valueChanged)
        notificationSwitch.centerYAnchor.constraint(equalTo: notificationButton.centerYAnchor).isActive = true
        notificationSwitch.rightAnchor.constraint(equalTo: notificationButton.rightAnchor, constant: -12).isActive = true
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func notificationButtonSwitched() {
        print("Notification option switched.")
    }
    @objc func saveButtonPressed() {
        print("Save button pressed.")
    }
    @objc func handleLogout() {
        self.delegate?.logout()
    }
}
