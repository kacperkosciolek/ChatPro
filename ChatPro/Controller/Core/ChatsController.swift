//
//  ChatsController.swift
//  ChatPro
//
//  Created by Kacper on 25/04/2022.
//

import UIKit

private let friendCellIdentifier = "ChatFriendCell"
private let groupCellIdentifier = "ChatGroupCell"

class ChatsController: UITableViewController {
    
    var chats = [Chat]() {
        didSet { tableView.reloadData() }
    }
    var user: User? {
        didSet { configureProfileControllerBar() }
    }
    let createGroupButton = CreateGroupButton(title: "Create a group",
                                                width: 32, height: 32)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        configureTableView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetchChats()
        observeChatsChanges()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ChatsManager.shared.removeObservers()
    }
    func fetchChats() {
        ChatsManager.shared.fetchChats { chats in

            self.chats = chats.sorted(by: { $0.timestamp > $1.timestamp })
        }
    }
    func observeChatsChanges() {
        ChatsManager.shared.observeChatsChanges {
            self.fetchChats()
        }
    }
    func configureTableView() {
        tableView.register(FriendChatCell.self, forCellReuseIdentifier: friendCellIdentifier)
        tableView.register(GroupChatCell.self, forCellReuseIdentifier: groupCellIdentifier)
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
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
        
        createGroupButton.addTarget(self, action: #selector(handleCreateGroup), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create a group", style: .plain, target: self, action: #selector(handleCreateGroup))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createGroupButton)
    }
    
    @objc func handleCreateGroup() {
        let controller = CreateGroupController(config: .createGroup)
        self.navigationController?.pushViewController(controller, animated: true)
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
        return chats.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
    
        if chats[indexPath.row] is Friend {
            let friendCell = tableView.dequeueReusableCell(withIdentifier: friendCellIdentifier, for: indexPath) as! FriendChatCell
            friendCell.friend = chats[indexPath.row] as? Friend
            cell = friendCell
        } else {
            let groupCell = tableView.dequeueReusableCell(withIdentifier: groupCellIdentifier, for: indexPath) as! GroupChatCell
            groupCell.group = chats[indexPath.row] as? Group
            cell = groupCell
        }
        cell.selectionStyle = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller: UIViewController
        let chat = chats[indexPath.row]
        
        if chat is Friend {
            controller = FriendConversationController(friend: chat as! Friend)
        } else {
            controller = GroupConversationController(group: chat as! Group)
        }
        if !chat.isRevealed { ChatsManager.shared.setChatAsRevealed(forChat: chat) }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
