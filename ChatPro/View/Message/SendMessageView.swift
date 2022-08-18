//
//  MessageTextView.swift
//  ChatPro
//
//  Created by Kacper on 15/05/2022.
//

import UIKit
import AMResizingTextView

protocol SendMessageDelegate: AnyObject {
    func sendMessage(text: String)
    func sendImage()
}
class SendMessageView: UIView {
    private let messageTextView: ResizingTextView = {
        let messageView = ResizingTextView()
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.textColor = .black
        messageView.backgroundColor = .systemBlue.withAlphaComponent(0.05)
        messageView.layer.cornerRadius = 20
        messageView.layer.borderWidth = 1
        messageView.layer.borderColor = UIColor.systemBlue.cgColor
        messageView.font = UIFont.systemFont(ofSize: 18)
        return messageView
    }()
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Send message.."
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray.withAlphaComponent(0.8)
        return label
    }()
    private let sendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "custom.paperplane.fill")?.withTintColor(.systemBlue), for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    private let imageButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "photo"), for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(handleSendImage), for: .touchUpInside)
        return button
    }()
    weak var delegate: SendMessageDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        messageTextView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        
        addSubview(imageButton)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
      
        let stack = UIStackView(arrangedSubviews: [messageTextView, sendMessageButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        stack.axis = .horizontal
        addSubview(stack)
        
        let stackConstraints = [
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leftAnchor.constraint(equalTo: imageButton.rightAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        imageButton.centerYAnchor.constraint(equalTo: stack.centerYAnchor).isActive = true
        
        NSLayoutConstraint.activate(stackConstraints)
        
        addSubview(placeholderLabel)
        placeholderLabel.topAnchor.constraint(equalTo: messageTextView.topAnchor, constant: 12).isActive = true
        placeholderLabel.leftAnchor.constraint(equalTo: messageTextView.leftAnchor, constant: 12).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextViewTapped), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func handleSendMessage() {
        guard messageTextView.text.isEmpty == false else { return }
        
        self.delegate?.sendMessage(text: messageTextView.text)
        messageTextView.text = ""
    }
    @objc func handleSendImage() {
        self.delegate?.sendImage()
    }
    @objc func handleTextViewTapped() {
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
    }
}
