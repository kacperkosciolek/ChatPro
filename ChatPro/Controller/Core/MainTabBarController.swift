//
//  MainTabBarController.swift
//  ChatPro
//
//  Created by Kacper on 25/04/2022.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let chats = nav.viewControllers.first as? ChatsController else { return }
            
            chats.user = user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        configureViewControllers()
        fetchUser()
    }
    func fetchUser() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        UserManager.fetchUser(uid: currentUid) { user in
            self.user = user
        }
    }
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let login = LoginController()
                login.delegate = self
                let nav = UINavigationController(rootViewController: login)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    func configureViewControllers() {
        let chats = UINavigationController(rootViewController: ChatsController())
        let search = UINavigationController(rootViewController: SearchController())
        let users = UINavigationController(rootViewController: NotificationController())
        
        chats.tabBarItem.image = UIImage(systemName: "message")
        search.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        users.tabBarItem.image = UIImage(systemName: "person")
        
        chats.title = "Chats"
        search.title = "Search"
        users.title = "Users"
        
        tabBar.tintColor = .systemBlue
        
        viewControllers = [chats, search, users]
    }
}
extension MainTabBarController: AuthDelegate {
    func authenticationDidComplete() {
        configureViewControllers()
        fetchUser()
        print("Authentication did complete.")
        self.dismiss(animated: true, completion: nil)
    }
}

