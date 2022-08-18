//
//  SearchController.swift
//  ChatPro
//
//  Created by Kacper on 25/04/2022.
//

import UIKit
import Firebase

private let cellIdentifier = "UserCell"

class SearchController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)

    private var users = [User]() {
        didSet { tableView.reloadData() }
    }
    var filteredUsers: [User] = []

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search"
        configureTableView()
        fetchUsers()
        configureSearchController()
    }
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    func configureTableView() {
        tableView.register(UserCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 70
    }
    func fetchUsers() {
        UserManager.fetchUsers { users in
            self.users = users
        }
    }
    func filterContent(_ searchText: String) {
        filteredUsers = users.filter({ (user: User) -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        }
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserCell
        cell.selectionStyle = .none
        
        let user = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
//        let user: User
//
//        if isFiltering {
//            user = filteredUsers[indexPath.row]
//        } else {
//            user = users[indexPath.row]
//        }
        if Auth.auth().currentUser?.uid == users[indexPath.row].uid {
            self.users.remove(at: indexPath.row)
        }
        cell.user = user
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileController = ProfileController()
        
        if isFiltering {
            profileController.user = filteredUsers[indexPath.row]
        } else {
            profileController.user = users[indexPath.row]
        }
        navigationController?.pushViewController(profileController, animated: true)
    }
}
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContent(searchBar.text!)
    }
}
