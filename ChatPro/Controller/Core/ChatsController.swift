//
//  ChatsController.swift
//  ChatPro
//
//  Created by Kacper on 25/04/2022.
//

import UIKit
import SDWebImage
import Firebase

private let cellIdentifier = "ChatCell"

class ChatsController: UITableViewController {
    
    var friends = [User]() {
        didSet { tableView.reloadData() }
    }
    var user: User? {
        didSet {
            configureProfileControllerBar()
            fetchFriends()
    
            UserManager.observeChatChanges { user in

                // self.fetchFriends()
                                
                // for optimization
                if user.isMessage == false {
                    if let i = self.friends.firstIndex(where: { user.uid == $0.uid }) {
                        self.friends[i] = user
                    }
                } else {
                    if user.uid == self.friends.first?.uid { self.friends[0] = user; return }
                    
                    self.friends.removeAll(where: { $0.uid == user.uid })
                    self.friends.insert(user, at: 0)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.title = "Chats"
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
    }
    func fetchFriends() {
        UserManager.fetchFriends { friends in
            self.friends = friends.sorted(by: { $0.timestamp > $1.timestamp })
        }
    }
    func configureProfileControllerBar() {
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true

        profileImageView.layer.cornerRadius = 18
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.masksToBounds = true
        profileImageView.sd_setImage(with: user?.profileImage, completed: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageViewTap))
        profileImageView.addGestureRecognizer(tap)
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }

    @objc func handleProfileImageViewTap() {
        guard let user = user else { return }
        
        let controller = ProfileController()
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
}
extension ChatsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatCell
        cell.selectionStyle = .none
        cell.friend = friends[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationController = ConversationController()
        conversationController.friend = friends[indexPath.row]
        
        ChatManager.setConversationAsRevealed(forUser: friends[indexPath.row])
    
        self.navigationController?.pushViewController(conversationController, animated: true)
    }
}


