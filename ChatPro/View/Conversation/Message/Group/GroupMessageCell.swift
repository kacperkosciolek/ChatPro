//
//  GroupMessageCell.swift
//  ChatPro
//
//  Created by Kacper on 01/12/2022.
//

import UIKit

private let cellIdentifier = "UserImageCell"

class GroupMessageCell: MessageCell {
    var profileImages: [URL]?
    
    var senderNicknameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(senderNicknameLabel)
    }
    func setCollectionViewForMessage(for view: UIView, dataSource: UICollectionViewDataSource) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 20, height: 20)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = dataSource
        cv.register(UserImageCell.self, forCellWithReuseIdentifier: cellIdentifier)
        cv.semanticContentAttribute = .forceRightToLeft

        addSubview(cv)
        cv.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cv.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        cv.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        cv.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cv.reloadData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension GroupMessageCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImages?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! UserImageCell
        cell.profileImage = profileImages?[indexPath.row]
        return cell
    }
}
