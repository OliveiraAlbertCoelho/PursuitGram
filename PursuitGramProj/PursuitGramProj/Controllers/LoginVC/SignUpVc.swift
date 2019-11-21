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
        setUpUIObjects()
    }
    lazy var signUpHeader: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
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
        textField.addTarget(self, action: #selector(validateFields), for: .touchUpInside)
        return textField
        
    }()
    lazy var passwordTextField: UITextField = {
         let textField = UITextField()
         textField.placeholder = "Enter Password"
         textField.font = UIFont(name: "Verdana", size: 14)
         textField.backgroundColor = .white
         textField.borderStyle = .bezel
         textField.autocorrectionType = .no
         textField.isSecureTextEntry = true
         textField.addTarget(self, action: #selector(validateFields), for: .touchUpInside)
         return textField
     }()
    lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    private func setUpUIObjects(){
        setUpHeader()
        setupSignUpStack()
    }
    @objc func validateFields() {
           guard emailTextField.hasText, passwordTextField.hasText else {
               createButton.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 0.5)
               createButton.isEnabled = false
               return
           }
           createButton.isEnabled = true
           createButton.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 1)
       }
    private func setUpHeader() {
        view.addSubview(signUpHeader)
        signUpHeader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            signUpHeader.heightAnchor.constraint(equalToConstant: 50)])
    }
    private func setupSignUpStack() {
            let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,createButton])
            stackView.axis = .vertical
            stackView.spacing = 15
            stackView.distribution = .fillEqually
            self.view.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: signUpHeader.topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 130)])
        }
}
