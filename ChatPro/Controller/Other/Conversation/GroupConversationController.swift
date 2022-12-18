//
//  GroupConversationController.swift
//  ChatPro
//
//  Created by Kacper on 28/11/2022.
//
import UIKit
import Firebase
import WebKit

private let rightTextIdentifier = "GroupRightTextCell"
private let leftTextIdentifier = "GroupLeftTextCell"
private let rightImageIdentifier = "GroupRightImageCell"
private let leftImageIdentifier = "GroupLeftImageCell"
private let notificationIdentifier = "GroupNotificationCell"

class GroupConversationController: UIViewController, ConversationController {
    var group: Group
    let tableView = UITableView()
    var sendMessageView = SendMessageView()
    
    var elements = [ConversationElement]()
    
    var webView: WKWebView!
    
    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
        loadConversation()
        fetchMembers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        ConversationManager.shared.setConversationStatus(isOpen: true, chat: group)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        nc.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        NotificationCenter.default.removeObserver(self)
        
        ConversationManager.shared.removeObservers(chat: group)
        ConversationManager.shared.setConversationStatus(isOpen: false, chat: group)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        observeMembersChanges(groupId: group.id)
    }
    func configureTableView() {
        tableView.dataSource = self
        tableView.register(GroupRightTextCell.self, forCellReuseIdentifier: rightTextIdentifier)
        tableView.register(GroupLeftTextCell.self, forCellReuseIdentifier: leftTextIdentifier)
        tableView.register(GroupRightImageCell.self, forCellReuseIdentifier: rightImageIdentifier)
        tableView.register(GroupLeftImageCell.self, forCellReuseIdentifier: leftImageIdentifier)
        tableView.register(GroupNotificationCell.self, forCellReuseIdentifier: notificationIdentifier)
    }
    func configureUI() {
        navigationItem.title = "Conversation"
        sendMessageView.delegate = self
        
        view.addSubview(sendMessageView)
        view.addSubview(tableView)
        configureConversationSendMessageView(sendMessageView: sendMessageView)
        configureConversationTableView(tableView: tableView, sendMessageView: sendMessageView)
        
        let manageBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        manageBtn.setTitle("Manage", for: .normal)
        manageBtn.setTitleColor(.systemBlue, for: .normal)
        manageBtn.layer.borderColor =  UIColor.systemBlue.cgColor
        manageBtn.layer.borderWidth = 2
        manageBtn.layer.cornerRadius = 16
        manageBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        manageBtn.contentEdgeInsets = UIEdgeInsets(top: 5,left: 8,bottom: 5,right: 8)
        manageBtn.layer.masksToBounds = true
        manageBtn.addTarget(self, action: #selector(handleManageGroup), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Members", style: .plain, target: self, action: #selector(handleManageGroup))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: manageBtn)
    }
    @objc func handleManageGroup() {
        let controller = GroupMembersController(group: group)
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func appMovedToBackground() {
        ConversationManager.shared.setConversationStatus(isOpen: false, chat: group)
    }
    @objc func appMovedToForeground() {
        ConversationManager.shared.setConversationStatus(isOpen: true, chat: group)
        fetchMembers()
        
        ChatsManager.shared.fetchChat(with: group.id) { chat in
            if !chat.isRevealed { ChatsManager.shared.setChatAsRevealed(forChat: chat) }
        }
    }
    func loadConversation() {
        ConversationManager.shared.loadGroupConversation(with: group.conversationKey) { elements in
            self.elements = elements.sorted(by: { $0.timestamp < $1.timestamp })
            self.tableView.reloadData()
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.elements.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    func fetchMembers() {
        ConversationManager.shared.fetchMembers(groupId: group.id) { members in
            var members = members
            members.removeAll(where: { $0.uid == Auth.auth().currentUser?.uid })
            self.group.members = members
            self.tableView.reloadData()
        }
    }
    func observeMembersChanges(groupId: String) {
        ConversationManager.shared.observeMembersChanges(groupId: groupId) {
            self.fetchMembers()
        }
    }
    func assignMemberToReadMessage(message: Message, row: Int) {
        let message = (self.elements[row] as! GroupMessage)
        
        guard let members = self.group.members?.sorted(by: {
            $0.timestampOfRevealed > $1.timestampOfRevealed
        }) else { return }
        
        var profileImages: [URL] = []
        
        for member in members {
            guard let profileImage = member.profileImage else { return }
            
            if message.sender == member.uid { message.nickname = member.nickname }
            
            while member.readMessage == message.id {
                profileImages.append(profileImage)
                break
            }
        }
        message.profileImages = profileImages
    }
}
extension GroupConversationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        
        if elements[indexPath.row] is Message {
            let message = elements[indexPath.row] as! Message
            
            assignMemberToReadMessage(message: message, row: indexPath.row)
            
            if message.sender == Auth.auth().currentUser?.uid {
                switch message.messageType {
                case .text:
                    let messageCell = tableView.dequeueReusableCell(withIdentifier: rightTextIdentifier, for: indexPath) as! GroupRightTextCell
                    messageCell.message = message as? GroupTextMessage
                    messageCell.delegate = self
                    cell = messageCell
                case .image:
                    let imageCell = tableView.dequeueReusableCell(withIdentifier: rightImageIdentifier, for: indexPath) as! GroupRightImageCell
                    imageCell.message = message as? GroupImageMessage
                    imageCell.delegate = self
                    cell = imageCell
                default: break
                }
            } else {
                switch message.messageType {
                case .text:
                    let messageCell = tableView.dequeueReusableCell(withIdentifier: leftTextIdentifier, for: indexPath) as! GroupLeftTextCell
                    messageCell.message = message as? GroupTextMessage
                    messageCell.delegate = self
                    cell = messageCell
                case .image:
                    let imageCell = tableView.dequeueReusableCell(withIdentifier: leftImageIdentifier, for: indexPath) as! GroupLeftImageCell
                    imageCell.message = message as? GroupImageMessage
                    imageCell.delegate = self
                    cell = imageCell
                default: break
                }
            }
        } else {
            let notificationCell = tableView.dequeueReusableCell(withIdentifier: notificationIdentifier, for: indexPath) as! GroupNotificationCell
            notificationCell.notification = elements[indexPath.row] as? GroupNotification
            cell = notificationCell
            
        }
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}
extension GroupConversationController: MovingFromParentDelegate {
    func movedFromParent() {
        ConversationManager.shared.setConversationStatus(isOpen: true, chat: group)
        
        loadConversation()
        fetchMembers()
        
        ChatsManager.shared.fetchChat(with: group.id) { chat in
            if !chat.isRevealed { ChatsManager.shared.setChatAsRevealed(forChat: chat) }
        }
    }
}
extension GroupConversationController: SendMessageDelegate {
    func sendMessage(text: String) {
        ConversationManager.shared.uploadGroupMessage(group: group, config: .text(text))
    }
    func sendImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
}
extension GroupConversationController: URLDelegate {
    func urlPressed(_ withUrl: String) {
        tableView.isHidden = true
        sendMessageView.isHidden = true
        let myURL = URL(string: withUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
extension GroupConversationController: WKUIDelegate {
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
}
extension GroupConversationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        ConversationManager.shared.uploadGroupMessage(group: group, config: .image(image))
        self.dismiss(animated: true, completion: nil)
    }
}
extension GroupConversationController: ImageDelegate {
    func imagePressed(image: URL) {
        let controller = ImageController()
        controller.image = image
        present(controller, animated: true)
    }
}
