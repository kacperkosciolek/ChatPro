//
//  FriendConversationController.swift
//  ChatPro
//
//  Created by Kacper on 28/11/2022.
//

import UIKit
import Firebase
import WebKit

private let rightTextIdentifier = "FriendRightTextCell"
private let leftTextIdentifier = "FriendLeftTextCell"
private let rightImageIdentifier = "FriendRightImageCell"
private let leftImageIdentifier = "FriendLeftImageCell"

class FriendConversationController: UIViewController, ConversationController {
    var friend: Friend
    let tableView = UITableView()
    var sendMessageView = SendMessageView()
    
    var messages = [Message]()
    
    var webView: WKWebView!
    
    init(friend: Friend) {
        self.friend = friend
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
        observeFriendReadMessage(friendId: friend.id)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        ConversationManager.shared.setConversationStatus(isOpen: true, chat: friend)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        nc.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        NotificationCenter.default.removeObserver(self)
        
        ConversationManager.shared.removeObservers(chat: friend)
        ConversationManager.shared.setConversationStatus(isOpen: false, chat: friend)
    }
    func configureTableView() {
        tableView.dataSource = self
        tableView.register(FriendRightTextCell.self, forCellReuseIdentifier: rightTextIdentifier)
        tableView.register(FriendLeftTextCell.self, forCellReuseIdentifier: leftTextIdentifier)
        tableView.register(FriendRightImageCell.self, forCellReuseIdentifier: rightImageIdentifier)
        tableView.register(FriendLeftImageCell.self, forCellReuseIdentifier: leftImageIdentifier)
    }
    func configureUI() {
        navigationItem.title = "Conversation"
        sendMessageView.delegate = self
        
        view.addSubview(sendMessageView)
        view.addSubview(tableView)
        configureConversationSendMessageView(sendMessageView: sendMessageView)
        configureConversationTableView(tableView: tableView, sendMessageView: sendMessageView)
    }
    @objc func appMovedToBackground() {
        ConversationManager.shared.setConversationStatus(isOpen: false, chat: friend)
    }
    @objc func appMovedToForeground() {
        ConversationManager.shared.setConversationStatus(isOpen: true, chat: friend)
        
        ChatsManager.shared.fetchChat(with: friend.id) { chat in
            if !chat.isRevealed { ChatsManager.shared.setChatAsRevealed(forChat: chat) }
        }
    }
    func loadConversation() {
        ConversationManager.shared.loadFriendConversation(with: friend.conversationKey) { messages in
            self.messages = messages.sorted(by: { $0.timestamp < $1.timestamp })
            self.tableView.reloadData()
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    func observeFriendReadMessage(friendId: String) {
        ConversationManager.shared.observeFriendReadMessage(friendId: friendId) { readMessageId in
            self.friend.readMessage = readMessageId
            self.tableView.reloadData()
        }
    }
    func assignFriendToReadMessage(message: Message, row: Int) {
        let message = self.messages[row] as! FriendMessage
        
        message.profileImage = nil
        
        if message.id == friend.readMessage { message.profileImage = friend.profileImage }
    }
}
extension FriendConversationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        let message = messages[indexPath.row]

        assignFriendToReadMessage(message: message, row: indexPath.row)
        
        if message.sender == Auth.auth().currentUser?.uid {
            switch message.messageType {
            case .text:
                let messageCell = tableView.dequeueReusableCell(withIdentifier: rightTextIdentifier, for: indexPath) as! FriendRightTextCell
                messageCell.message = message as? FriendTextMessage
                messageCell.delegate = self
                cell = messageCell
            case .image:
                let imageCell = tableView.dequeueReusableCell(withIdentifier: rightImageIdentifier, for: indexPath) as! FriendRightImageCell
                imageCell.message = message as? FriendImageMessage
                imageCell.delegate = self
                cell = imageCell
            default: break
            }
        } else {
            switch message.messageType {
            case .text:
                let messageCell = tableView.dequeueReusableCell(withIdentifier: leftTextIdentifier, for: indexPath) as! FriendLeftTextCell
                messageCell.message = message as? FriendTextMessage
                messageCell.delegate = self
                cell = messageCell
            case .image:
                let imageCell = tableView.dequeueReusableCell(withIdentifier: leftImageIdentifier, for: indexPath) as! FriendLeftImageCell
                imageCell.message = message as? FriendImageMessage
                imageCell.delegate = self
                cell = imageCell
            default: break
            }
        }
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}
extension FriendConversationController: SendMessageDelegate {
    func sendMessage(text: String) {
        ConversationManager.shared.uploadFriendMessage(friend: friend, config: .text(text))
    }
    func sendImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
}
extension FriendConversationController: URLDelegate {
    func urlPressed(_ withUrl: String) {
        tableView.isHidden = true
        sendMessageView.isHidden = true
        let myURL = URL(string: withUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
extension FriendConversationController: WKUIDelegate {
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
}
extension FriendConversationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        ConversationManager.shared.uploadFriendMessage(friend: friend, config: .image(image))
        self.dismiss(animated: true, completion: nil)
    }
}
extension FriendConversationController: ImageDelegate {
    func imagePressed(image: URL) {
        let controller = ImageController()
        controller.image = image
        present(controller, animated: true)
    }
}

