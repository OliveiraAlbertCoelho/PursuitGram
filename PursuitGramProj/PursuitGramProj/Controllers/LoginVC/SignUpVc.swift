//
//  SignUpVc.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/20/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpVc: UIViewController {
    //MARK: - lifecycle methods
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
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
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
        textField.textContentType = .oneTimeCode
        textField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
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
        button.addTarget(self, action: #selector(trySignUp), for: .touchUpInside)
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
        createButton.backgroundColor = UIColor(red: 255/255, green: 60/255, blue: 0/255, alpha: 1)
    }
    
    @objc func trySignUp(){
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(title: "Oops", message: "Please fill out all fields")
            return
        }
        guard email.isValidEmail else {
            showAlert(title: "Error", message: "Please enter a valid email")
            return
        }
        guard password.isValidPassword else {
            showAlert(title: "Error", message: "Please enter a valid password. Passwords must have at least 8 characters.")
            return
        }
     FirebaseAuthService.manager.createNewUser(email: email.lowercased(), password: password) { [weak self] (result) in
                   self?.handleCreateAccountResponse(with: result)
               }
           }
           
           //MARK: Private methods
           
           private func showAlert(with title: String, and message: String) {
               let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
               alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
               present(alertVC, animated: true, completion: nil)
           }
           private func handleCreateAccountResponse(with result: Result<User, Error>) {
               DispatchQueue.main.async { [weak self] in
                   switch result {
                   case .success(let user):
                       FirestoreService.manager.SaveUser(user: AppUser(from: user)) { [weak self] newResult in
                           self?.handleCreatedUserInFirestore(result: newResult)
                       }
                   case .failure(let error):
                       self?.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
                   }
               }
           }
           
           private func handleCreatedUserInFirestore(result: Result<(), Error>) {
               switch result {
               case .success:
                   guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                       else {
                           //MARK: TODO - handle could not swap root view controller
                           return
                   }
                   //MARK: TODO - refactor this logic into scene delegate
                   UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                       if FirebaseAuthService.manager.currentUser?.photoURL != nil {
                           window.rootViewController = PursuitGramTabBarVC()
                       } else {
                           window.rootViewController = {
                            let profileSetupVC = PursuitGramTabBarVC()
                            return profileSetupVC
                           }()
                       }
                   }, completion: nil)
               case .failure(let error):
                   self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
               }
           }
    private func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
    
    //MARK: - UI Constraints
    
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
