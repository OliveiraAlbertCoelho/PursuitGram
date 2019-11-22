//
//  editUserProfileVC.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/22/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class EditUserProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    lazy var profileImage: UIImageView = {
          let image = UIImageView()
           image.backgroundColor = .gray
           image.image = UIImage(systemName: "person")
           return image
       }()
       lazy var userName: UITextField = {
           let textField = UITextField()
           textField.placeholder = "Please enter userName"
           textField.font = UIFont(name: "Verdana", size: 14)
           textField.backgroundColor = .white
           textField.borderStyle = .bezel
           textField.layer.cornerRadius = 5
           textField.autocorrectionType = .no
           return textField
       }()
    lazy var addImage: UIButton = {
        let button = UIButton()
        button.setTitle("Add Image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 5
        return button
    }()
        lazy var saveProfile: UIButton = {
        let button = UIButton()
            button.setTitle("Save Profile", for: .normal)
              button.setTitleColor(.white, for: .normal)
              button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
              button.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 1)
              button.layer.cornerRadius = 5
        return button
        }()
    

}
