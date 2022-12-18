//
//  CreateGroupController.swift
//  ChatPro
//
//  Created by Kacper on 20/08/2022.
//

import UIKit
import Firebase

private let cellIdentifier = "UserAddingCell"
private let imageIdentifier = "AddedUserCell"

enum CreateGroupControllerConfiguration {
    case createGroup
    case addNewMember(Group)
}
protocol NewMemberDelegate {
    func newMemberAdded()
}
class CreateGroupController: UIViewController {
    
    private let config: CreateGroupControllerConfiguration
    
    var delegate: NewMemberDelegate?
    let searchController = UISearchController(searchResultsController: nil)
    var tableView = UITableView()
    let addMembersButton = CreateGroupButton(title: "Add", width: 82, height: 32)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(AddedUserCell.self, forCellWithReuseIdentifier: imageIdentifier)
        return cv
    }()

    private var users = [User]() {
        didSet {
            tableView.reloadData() }
    }
    var filteredUsers: [User] = []
    
    var selectedUsers: [User] = [] {
        didSet { collectionView.reloadData() }
    }
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    init(config: CreateGroupControllerConfiguration) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
      
        configureSearchController()
        configureTableView()
        fetchUsers()
        configureRightBarButton()
    }
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search Users"
        navigationItem.searchController = searchController
    }
    func configureTableView() {
         tableView.register(UserAddingCell.self, forCellReuseIdentifier: cellIdentifier)
         
         view.addSubview(collectionView)
         collectionView.heightAnchor.constraint(equalToConstant: view.frame.width / 6).isActive = true
         collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
         collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
         collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
       
         tableView.translatesAutoresizingMaskIntoConstraints = false
         tableView.dataSource = self
         tableView.delegate = self
     
         view.addSubview(tableView)
         tableView.rowHeight = 70
         tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
         tableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    func configureRightBarButton() {
        addMembersButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(buttonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addMembersButton)
    }
    func fetchUsers() {
        UserManager.fetchUsers { users in
            var users = users
            
            if case .addNewMember(let group) = self.config {
                group.members.forEach { member in
                    users.removeAll(where: { $0.uid == member.uid })
                }
            }
            self.users = users
        }
    }
    func filterContent(_ searchText: String) {
        filteredUsers = users.filter({ (user: User) -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    @objc func buttonPressed() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        if case .addNewMember(let group) = self.config {
            selectedUsers.forEach { selectedUser in
                ChatsManager.shared.addNewMember(group: group, newMember: selectedUser)
                
                UserManager.fetchUser(uid: currentUser) { user in
                    ConversationManager.shared.uploadNewMemberNotification(key: group.conversationKey,
                                                                           member: user.username,
                                                                           newMember: selectedUser.username) {
                        self.delegate?.newMemberAdded()
                    }
                }
            }
        } else {
            if selectedUsers.count < 2 { return }
            
            UserManager.fetchUser(uid: currentUser) { user in
                self.selectedUsers.insert(user, at: 0)
                
                ChatsManager.shared.createGroupChat(with: self.selectedUsers)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}
extension CreateGroupController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        }
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserAddingCell
        cell.selectionStyle = .none

        let user = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]

        if Auth.auth().currentUser?.uid == users[indexPath.row].uid {
            self.users.remove(at: indexPath.row)
        }
        cell.user = user

        return cell
    }
}
extension CreateGroupController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserAddingCell
        cell.selectionStyle = .none
        
        let user = self.users[indexPath.row]
    
        cell.toggleUser { isUserAdded in
            if isUserAdded {
                self.selectedUsers.append(user)
                self.collectionView.scrollToItem(at: IndexPath(row: self.selectedUsers.count - 1, section: 0), at: .right, animated: true)
            } else {
                if let i = self.selectedUsers.firstIndex(where: { $0.uid == user.uid }) {
                    self.selectedUsers.remove(at: i)
                }
            }
        }
    }
}
extension CreateGroupController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContent(searchBar.text!)
    }
}
extension CreateGroupController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedUsers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageIdentifier, for: indexPath) as! AddedUserCell
        cell.user = selectedUsers[indexPath.row]
        cell.delegate = self
        cell.rejectUserButton.tag = indexPath.row
        return cell
    }
}
extension CreateGroupController: RejectUserDelegate {
    func rejectUserButtonPressed(withUser user: User, row: Int) {
        if let i = users.firstIndex(where: { user.uid == $0.uid }) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! UserAddingCell
            
            cell.toggleUser { _ in }
        }
        self.selectedUsers.remove(at: row)
    }
}
extension CreateGroupController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 6
        return CGSize(width: width, height: width)
    }
}
