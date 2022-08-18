//
//  ProfileController.swift
//  ChatPro
//
//  Created by Kacper on 25/04/2022.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    var profileHeader = ProfileHeaderView()
    var profileSettings = ProfileSettings()
    var customView = UIView()
    var divider = UIView()
    
    var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            UserManager.fetchNumberOfFriends(forUid: user.uid) { numberOfFriends in
                self.profileHeader.viewModel = ProfileHeaderViewModel(user: user, numberOfFriends: numberOfFriends)
            }
        }
    }
    private var profileButton = ProfileButton(title: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(profileHeader)
        profileHeader.translatesAutoresizingMaskIntoConstraints = false
        profileHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileHeader.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        profileHeader.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemBlue
        
        let dividerConstraints = [
            divider.widthAnchor.constraint(equalToConstant: view.frame.width - 45),
            divider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            divider.heightAnchor.constraint(equalToConstant: 3),
            divider.topAnchor.constraint(equalTo: profileHeader.bottomAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(dividerConstraints)
        
        view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: divider.bottomAnchor).isActive = true
        customView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        customView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        if Auth.auth().currentUser?.uid == user?.uid {
            view.addSubview(profileSettings)
            profileSettings.delegate = self
            profileSettings.translatesAutoresizingMaskIntoConstraints = false
            profileSettings.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileSettings.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
            profileSettings.widthAnchor.constraint(equalToConstant: view.frame.width - 50).isActive = true
            profileSettings.heightAnchor.constraint(equalToConstant: 340).isActive = true
        } else {
            view.addSubview(profileButton)
            profileButton.topAnchor.constraint(equalTo: self.divider.bottomAnchor, constant: 28).isActive = true
            profileButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            profileButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
            profileButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
            profileButton.addTarget(self, action: #selector(handleAddButtonTapped), for: .touchUpInside)
            
            guard let user = user else {
                return
            }
            UserManager.checkIfUserIsFriend(uid: user.uid) { isFriend in
                let profileButtonViewModel = ProfileButtonViewModel(userIsFriend: isFriend)
                self.profileButton.setTitle(profileButtonViewModel.titleOfButton, for: .normal)
            }
        }
    }
    @objc func handleAddButtonTapped() {
        guard let user = user else {
            return
        }
        UserManager.checkIfUserIsFriend(uid: user.uid) { isFriend in
            if isFriend {
                let controller = ConversationController()
                controller.friend = user
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                UserManager.sendRequest(uid: user.uid) {
                    let alert = UIAlertController(title: "Request sent.", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
extension ProfileController: LogoutDelegate {
    func logout() {
        do {
            try Auth.auth().signOut()
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabBarController else { return }
            
            tab.checkIfUserIsLoggedIn()
        
            self.navigationController?.popViewController(animated: false)
            
        } catch let error {
            print("Error while log user out: \(error.localizedDescription)")
        }
    }
}

