//
//  AddedUserCell.swift
//  ChatPro
//
//  Created by Kacper on 29/08/2022.
//

import UIKit
import SDWebImage

protocol RejectUserDelegate: AnyObject {
    func rejectUserButtonPressed(withUser user: User, row: Int)
}
class AddedUserCell: UICollectionViewCell {
    
    var user: User? {
        didSet { configure() }
    }
    weak var delegate: RejectUserDelegate?
    
    private var userImageView: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    var rejectUserButton: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .white
        btn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        btn.layer.cornerRadius = 11
        btn.addTarget(self, action: #selector(rejectTheUser(sender:)), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "x.circle.fill")?.withTintColor(.darkGray, renderingMode: .alwaysOriginal), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userImageView)
        userImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        userImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        userImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        userImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        userImageView.layer.cornerRadius = frame.height / 2
        
        addSubview(rejectUserButton)
        rejectUserButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rejectUserButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func rejectTheUser(sender: UIButton) {
        guard let user = user else {return}

        self.delegate?.rejectUserButtonPressed(withUser: user, row: sender.tag)
    }
    func configure() {
        guard let profileImage = user?.profileImage else { return }
        userImageView.sd_setImage(with: profileImage)
    }
}

