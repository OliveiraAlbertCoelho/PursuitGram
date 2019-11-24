//
//  FirebaseStorage.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/22/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation
import FirebaseStorage

//switch on type of reference
enum typeOfReference{
    case post
    case profile
}
class FirebaseStorage {

    // 2 managers for separate tasks: one for posts and another for profile image
    static var profilemanager = FirebaseStorage(type: .profile)
    static var postManager = FirebaseStorage(type: .post)
        private let storage: Storage!
        private let storageReference: StorageReference
        private let imagesFolderReference: StorageReference
        
    init(type: typeOfReference) {
            storage = Storage.storage()
            storageReference = storage.reference()
        switch type {
            //this is the referece to the folder in firebase image folders
        case .post:
             imagesFolderReference = storageReference.child("postImage")
        case .profile:
              imagesFolderReference = storageReference.child("profileImage")
        }
        }
        
    //save images
        func storeImage(image: Data,  completion: @escaping (Result<URL,Error>) -> ()) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let uuid = UUID()
            let imageLocation = imagesFolderReference.child(uuid.description)
            imageLocation.putData(image, metadata: metadata) { (responseMetadata, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    imageLocation.downloadURL { (url, error) in
                        guard error == nil else {completion(.failure(error!));return}
                        guard let url = url else {completion(.failure(error!));return}
                        completion(.success(url))
                    }
                }
            }
        }
    //get images from firebase
    func getImages(profileUrl: String, completion: @escaping (Result<Data, Error>) -> ()){
        imagesFolderReference.storage.reference(forURL: profileUrl).getData(maxSize: 2000000) { (data, error) in
            if let error = error{
                completion(.failure(error))
            }else  if let data = data {
                completion(.success(data))
            }
        }
    }
    }

