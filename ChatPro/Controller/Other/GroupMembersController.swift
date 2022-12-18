//
//  GroupMembersController.swift
//  ChatPro
//
//  Created by Kacper on 31/10/2022.
//

import UIKit

protocol MovingFromParentDelegate {
    func movedFromParent()
}
private let cellIdentifier = "MemberCell"

class GroupMembersController: UITableViewController {
    var group: Group
    var delegate: MovingFromParentDelegate?
    
    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            self.delegate?.movedFromParent()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Members"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "person.crop.circle.badge.plus"), style: .plain, target: self, action: #selector(addNewMemberButtonPressed))
        configureTableView()
        fetchCurrentMember()
    }
    func configureTableView() {
        tableView.register(MemberCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 70
    }
    func fetchCurrentMember() {
        ConversationManager.shared.fetchCurrentMember(groupId: group.id) { currentMember in
            self.group.members.append(currentMember)
            self.tableView.reloadData()
        }
    }
    func updateMembers() {
        ConversationManager.shared.fetchMembers(groupId: group.id) { members in
            self.group.members = members
            self.tableView.reloadData()
        }
    }
    @objc func addNewMemberButtonPressed() {
        let controller = CreateGroupController(config: .addNewMember(group))
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension GroupMembersController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.members.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MemberCell
        cell.member = group.members[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = group.members[indexPath.row]
   
        let alert = UIAlertController(title: "Change the nickname.", message: "", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = member.nickname
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (_) in
            guard let textField = alert?.textFields![0] else { return }
            
            guard let newNickname = textField.text else { return }
            
            if newNickname == member.nickname { return }
            
            ConversationManager.shared.changeMemberNickname(groupId: self.group.id, memberId: member.uid, newNickname: newNickname) {
                self.group.members[indexPath.row].nickname = newNickname
                
                ConversationManager.shared.uploadNewNicknameNotification(key: self.group.conversationKey,
                                                                         newNickname: newNickname,
                                                                         oldNickname: member.nickname) {
                    self.tableView.reloadData()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
extension GroupMembersController: NewMemberDelegate {
    func newMemberAdded() {
        self.updateMembers()
    }
}
