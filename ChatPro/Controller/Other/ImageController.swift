//
//  ImageController.swift
//  ChatPro
//
//  Created by Kacper on 30/05/2022.
//

import UIKit
import SDWebImage

class ImageController: UIViewController {
    
    var image: URL?
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        confgiureImage()
    }
    func confgiureImage() {
        view.addSubview(imageView)
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        imageView.sd_setImage(with: image)
    }
}
