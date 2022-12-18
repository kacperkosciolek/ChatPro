//
//  NotificationController.swift
//  ChatPro
//
//  Created by Kacper on 25/04/2022.
//

import UIKit
import Firebase

private let cellIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    
    private var users = [User]() {
        didSet { tableView.reloadData() }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Users"
        configureTableView()
        fetchUsers()
    }
    func configureTableView() {
        tableView.register(NotificationCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 70
    }
    func fetchUsers() {
        UserManager.checkRequests { user in
            self.users.append(user)
        }
    }
}
extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NotificationCell
        cell.contentView.isUserInteractionEnabled = false
        cell.addFriendButton.tag = indexPath.row
        cell.rejectFriendButton.tag = indexPath.row
        cell.user = users[indexPath.row]
        cell.delegate = self
        return cell
    }
}
extension NotificationController: RequestDelegate {
    func addFriend(_ friend: User, _ numberOfRow: Int) {
        ChatsManager.shared.createFriendChat(with: friend)
        UserManager.removeRequest(uid: friend.uid)
        self.users.remove(at: numberOfRow)
        self.tableView.reloadData()
    }
    func rejectFriend(_ friend: User, _ numberOfRow: Int) {
        UserManager.removeRequest(uid: friend.uid)
        self.users.remove(at: numberOfRow)
        self.tableView.reloadData()
    }
}
