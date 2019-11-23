//
//  FirebaseStorage.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/22/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation
import FirebaseStorage

enum typeOfReference{
    case post
    case profile
}
class FirebaseStorage {
    static var profilemanager = FirebaseStorage(type: .profile)
    static var postManager = FirebaseStorage(type: .post)
        private let storage: Storage!
        private let storageReference: StorageReference
        private let imagesFolderReference: StorageReference
        
    init(type: typeOfReference) {
            storage = Storage.storage()
            storageReference = storage.reference()
        switch type {
        case .post:
             imagesFolderReference = storageReference.child("postImage")
        case .profile:
              imagesFolderReference = storageReference.child("profileImage")
        }
          
        }
        
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
    func getProfileImage(profileUrl: String, completion: @escaping (Result<Data, Error>) -> ()){
        imagesFolderReference.storage.reference(forURL: profileUrl).getData(maxSize: 2000000) { (data, error) in
            if let error = error{
                completion(.failure(error))
            }else  if let data = data {
                completion(.success(data))
            }
        }
    }
    }

