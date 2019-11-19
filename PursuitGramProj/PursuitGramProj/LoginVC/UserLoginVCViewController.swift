//
//  UserLoginVCViewController.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/19/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class UserLoginVCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    lazy var pursuitGramLogo: UILabel = {
        let label = UILabel()
        label.text = "Pursuitsgram"
        label.font = UIFont(name: "Verdana-Bold", size: 60)
        label.textColor = UIColor(red: 255/255, green: 86/255, blue: 0/255, alpha: 1.0)
         label.textAlignment = .center
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter email"
        field.font = UIFont(name: "Verdana", size: 14)
        field.borderStyle = .bezel
        field.autocorrectionType = .no
        return field
    }()
    lazy var passwordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter Password"
        field.font = UIFont(name: "Verdana", size: 14)
        field.borderStyle = .bezel
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        return field
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
    }()
    
}
