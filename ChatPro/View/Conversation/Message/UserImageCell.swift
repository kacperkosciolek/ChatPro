//
//  UserImageCell.swift
//  ChatPro
//
//  Created by Kacper on 09/10/2022.
//

import UIKit

class UserImageCell: UICollectionViewCell {
    var profileImage: URL? {
        didSet { configure() }
    }
    private var profileImageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileImageView)
        profileImageView.layer.cornerRadius = frame.height / 2
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = contentView.bounds
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure() {
        profileImageView.sd_setImage(with: profileImage)
    }
}
