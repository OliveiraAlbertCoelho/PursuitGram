//
//  UserProfileVc.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/21/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class UserProfileVc: UIViewController {
    var user: AppUser!
     var isCurrentUser = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    lazy var userImage: UIImageView = {
      let user = UIImageView()
      user.backgroundColor = .gray
      user.image = UIImage(systemName: "person")
      user.layer.cornerRadius = 15
    return user
    }()
    lazy var userName: UILabel = {
    let label = UILabel()
        label.text = "UserName not set"
    return label
    }()
    lazy var totalPost: UILabel = {
    let label = UILabel()
    label.text = "0 \n Posts"
    label.numberOfLines = 0
    
    return label
    }()
    
}
