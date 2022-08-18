//
//  ImageUploader.swift
//  ChatPro
//
//  Created by Kacper on 02/05/2022.
//

import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("\(error.localizedDescription) - Failed to upload image")
                return
            }
            storageRef.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
