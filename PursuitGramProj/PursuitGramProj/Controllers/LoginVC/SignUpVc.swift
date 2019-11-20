//
//  SignUpVc.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/20/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class SignUpVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    lazy var signUpHeader: UILabel = {
        let label = UILabel()
        label.text = "Pursuitsgram signUp"
        label.font = UIFont(name: "Verdana-Bold", size: 28)
        label.textColor = UIColor(red: 255/255, green: 86/255, blue: 0/255, alpha: 1.0)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    lazy var emailTextField: UITextField = {
     let textField = UITextField()
        textField.placeholder = "Enter email"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .white
        textField.borderStyle = .bezel
        textField.autocorrectionType = .no
        
        return textField
        
    }()
    

}
