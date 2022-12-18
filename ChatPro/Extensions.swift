//
//  Extensions.swift
//  ChatPro
//
//  Created by Kacper on 16/06/2022.
//

import UIKit

extension String {
    var isURL: Bool {
        guard !contains("..") else { return false }
    
        let head = "((http|https)://)?([(w|W)]{3}+\\.)?"
        let tail     = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
        let urlRegEx = head+"+(.)+"+tail
    
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)

        return urlTest.evaluate(with: trimmingCharacters(in: .whitespaces))
    }
}
extension MessageCell {
    func configureMessage(with view: UIView,
                          dateLabel: UILabel,
                          textMessageView: UIView? = nil,
                          profileImageView: UIImageView? = nil,
                          nicknameLabel: UILabel? = nil) {
        let messageView = textMessageView != nil ? textMessageView! : view
        
        dateLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: messageView.topAnchor, constant: -5).isActive = true
        
        if let textView = textMessageView {
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.layer.cornerRadius = 15
            
            let constraints = [
                textView.topAnchor.constraint(equalTo: view.topAnchor, constant: -10),
                textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -12),
                textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
                textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 12)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        if let profileImage = profileImageView {
            profileImage.bottomAnchor.constraint(equalTo: messageView.bottomAnchor).isActive = true
            profileImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        }
        if let nicknameLabel = nicknameLabel {
            nicknameLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor).isActive = true
            nicknameLabel.bottomAnchor.constraint(equalTo: messageView.topAnchor).isActive = true
        }
    }
    func setMessagePosition(with view: UIView,
                            topConstant: CGFloat,
                            leftConstant: CGFloat,
                            bottomConstant: CGFloat,
                            rightConstant: CGFloat) {
        let constraints = [
            view.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: leftConstant),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant),
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: rightConstant)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
extension UIViewController {
    func configureConversationSendMessageView(sendMessageView: UIView) {
        sendMessageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            sendMessageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            sendMessageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            sendMessageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    func configureConversationTableView(tableView: UITableView, sendMessageView: UIView) {
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: sendMessageView.topAnchor, constant: -20),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
