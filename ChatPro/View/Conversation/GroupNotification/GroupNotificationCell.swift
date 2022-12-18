//
//  GroupNotificationCell.swift
//  ChatPro
//
//  Created by Kacper on 05/11/2022.
//

import UIKit

class GroupNotificationCell: UITableViewCell {
    var notification: GroupNotification? {
        didSet { configureNotification() }
    }
    private var notificationLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(notificationLabel)
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationLabel.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        notificationLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        notificationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureNotification() {
        guard let notification = notification else { return }

        switch notification.notificationType {
        case .added:
            let viewModel = NewMemberNotificationViewModel(notification: notification as! NewMemberNotification)
            notificationLabel.text = viewModel.notificationText
        case .changed:
            let viewModel = NewNicknameNotificationViewModel(notification: notification as! NewNicknameNotification)
            notificationLabel.text = viewModel.notificationText
        }
    }
}
