//
//  FirebaseStorage.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/22/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStorage {
        static var manager = FirebaseStorage()
        
        private let storage: Storage!
        private let storageReference: StorageReference
        private let imagesFolderReference: StorageReference
        
        init() {
            storage = Storage.storage()
            storageReference = storage.reference()
            imagesFolderReference = storageReference.child("images")
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
                    //Try to get the actual URL for our image
                    imageLocation.downloadURL { (url, error) in
                        guard error == nil else {completion(.failure(error!));return}
                        //MARK: TODO - set up custom app errors
                        guard let url = url else {completion(.failure(error!));return}
                        completion(.success(url))
                    }
                }
            }
        }
    }
