//
//  Posts.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/23/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Post {
    let id: String
    let creatorID: String
    let dateCreated: Date?
    let imageUrl: String?

    var dateFormat: String {
        guard let date = dateCreated else{
            return "no date"
        }
      let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd MMM, yyyy hh:mm:ss"
        return dateFormatter.string(from: date)

    }
    
    init( creatorID: String, dateCreated: Date? = nil , imageUrl: String? = nil){
        self.creatorID = creatorID
        self.dateCreated = dateCreated
        self.imageUrl = imageUrl
        self.id = UUID().description
   
    }
    init? (from dict: [String: Any], id: String){
        guard let userId = dict["creatorID"] as? String,
         let userImage = dict["imageUrl"] as? String,
    
         let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else { return nil }
        self.creatorID = userId
        self.id = id
        self.dateCreated = dateCreated
        self.imageUrl = userImage
    }
    var fieldsDict: [String: Any] {
           return [
               "creatorID": self.creatorID,
               "imageUrl": self.imageUrl ?? "",
           ]
       }
    
}
