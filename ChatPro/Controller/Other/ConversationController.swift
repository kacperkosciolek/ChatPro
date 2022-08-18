//
//  ConversationController.swift
//  ChatPro
//
//  Created by Kacper on 25/04/2022.
//

import UIKit
import Firebase
import WebKit
import SDWebImage

private let rightMessageCellIdentifier = "RightMessageCell"
private let leftMessageCellIdentifier = "LeftMessageCell"
private let rightImageCellIdentifier = "RightImageCell"
private let leftImageCellIdentifier = "LeftImageCell"

class ConversationController: UIViewController {
    
    var friend: User?
    let tableView = UITableView()
    var sendMessageView = SendMessageView()
    
    private var messages = [Message]() {
        didSet { tableView.reloadData() }
    }
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        configureUI()

        guard let friend = friend else { return }

        UserManager.observeTimestampChanges(forUid: friend.uid) { timestamp in
            self.friend?.timestampOfRevealed = Date(timeIntervalSince1970: timestamp)
            self.tableView.reloadData()
        }
        fetchMessages()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let friendUid = friend?.uid else { return }
        UserManager.stateForTheConversation(friendUid: friendUid, isOpen: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        guard let friendUid = friend?.uid else { return }
        
        CONVERSATION.child(currentUser).child(friendUid).removeAllObservers()
        CONVERSATION.child(friendUid).child(currentUser).removeAllObservers()

        UserManager.stateForTheConversation(friendUid: friendUid, isOpen: false)
        
        USERS.child(friendUid).child("friends").child(currentUser).child("timestampOfRevealed").removeAllObservers()
    }
    func configureUI() {
        navigationItem.title = "Conversation"
        sendMessageView.delegate = self

        view.addSubview(sendMessageView)
        sendMessageView.translatesAutoresizingMaskIntoConstraints = false
        sendMessageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        sendMessageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        sendMessageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18).isActive = true
        
        tableView.dataSource = self
        tableView.register(RightMessageCell.self, forCellReuseIdentifier: rightMessageCellIdentifier)
        tableView.register(LeftMessageCell.self, forCellReuseIdentifier: leftMessageCellIdentifier)
        tableView.register(RightImageCell.self, forCellReuseIdentifier: rightImageCellIdentifier)
        tableView.register(LeftImageCell.self, forCellReuseIdentifier: leftImageCellIdentifier)
        tableView.separatorStyle = .none

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: -20),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    func fetchMessages() {
        guard let friend = self.friend else { return }
        
        ChatManager.fetchMessages(fromUid: friend.uid) { [self] messages in
            self.messages = messages.sorted(by: { $0.timestamp < $1.timestamp })
      
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
}
extension ConversationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if messages[indexPath.row].sender == Auth.auth().currentUser?.uid {
            if messages[indexPath.row].image == nil {
                let rightMessageCell = tableView.dequeueReusableCell(withIdentifier: rightMessageCellIdentifier, for: indexPath) as! RightMessageCell
                rightMessageCell.user = friend
                rightMessageCell.message = messages[indexPath.row]
                rightMessageCell.delegate = self
                cell = rightMessageCell
            } else {
                let rightImageCell = tableView.dequeueReusableCell(withIdentifier: rightImageCellIdentifier, for: indexPath) as! RightImageCell
                rightImageCell.user = friend
                rightImageCell.message = messages[indexPath.row]
                rightImageCell.delegate = self
                cell = rightImageCell
            }
        } else {
            if messages[indexPath.row].image == nil {
                let leftMessageCell = tableView.dequeueReusableCell(withIdentifier: leftMessageCellIdentifier, for: indexPath) as! LeftMessageCell
                leftMessageCell.user = friend
                leftMessageCell.message = messages[indexPath.row]
                leftMessageCell.delegate = self
                cell = leftMessageCell
            } else {
                let leftImageCell = tableView.dequeueReusableCell(withIdentifier: leftImageCellIdentifier, for: indexPath) as! LeftImageCell
                leftImageCell.user = friend
                leftImageCell.message = messages[indexPath.row]
                leftImageCell.delegate = self
                cell = leftImageCell
            }
        }
        cell.contentView.isUserInteractionEnabled = false
        return cell
    }
}
extension ConversationController: SendMessageDelegate {
    func sendMessage(text: String) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        guard let friend = self.friend else { return }
        
        ChatManager.uploadMessage(toUid: friend.uid, sender: currentUser, messageText: text, image: nil)
    }
    func sendImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
}
extension ConversationController: URLDelegate {
    func urlPressed(_ withUrl: String) {
        tableView.isHidden = true
        sendMessageView.isHidden = true
        let myURL = URL(string: withUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
extension ConversationController: WKUIDelegate {
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
}
extension ConversationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        guard let friend = self.friend else { return }
        
        ChatManager.uploadMessage(toUid: friend.uid, sender: currentUser, messageText: nil, image: image)
        self.dismiss(animated: true, completion: nil)
    }
}
extension ConversationController: ImageDelegate {
    func imagePressed(image: URL) {
        let controller = ImageController()
        controller.image = image
        present(controller, animated: true)
    }
}

