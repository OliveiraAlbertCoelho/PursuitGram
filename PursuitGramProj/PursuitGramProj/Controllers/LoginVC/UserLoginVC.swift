//
//  UserLoginVCViewController.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/19/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class UserLoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubViews()
        // Do any additional setup after loading the view.
    }
    // MARK: - UI objects
    lazy var pursuitGramLogo: UILabel = {
        let label = UILabel()
        label.text = "Pursuitsgram"
        label.font = UIFont(name: "Verdana-Bold", size: 40)
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
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return button
    }()
    lazy var createAccount: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Dont have an account?  ",
                                                        attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana", size: 14)!,
                                                                     NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up",attributes: [NSAttributedString.Key.font: UIFont(name: "Verdana-Bold", size: 14)!,
                                                                                 NSAttributedString.Key.foregroundColor:  UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        return button
    }()
    

 //MARK: - Objc functions
    @objc func loginAction(){
        guard let email = emailTextField.text, let password = passwordTextField.text else {
                showAlert(title: "Error", message: "Please fill out all fields.")
                return
            }
            //MARK: TODO - remove whitespace (if any) from email/password
            guard email.isValidEmail else {
                showAlert(title: "Error", message: "Please enter a valid email")
                return
            }
            guard password.isValidPassword else {
                showAlert(title: "Error", message: "Please enter a valid password. Passwords must have at least 8 characters.")
                return
            }
            
            FirebaseAuthService.manager.loginUser(email: email.lowercased(), password: password) { (result) in
                self.handleLoginResponse(with: result)
            }
        }
    @objc func showSignUp() {
          let signupVC = SignUpVc()
          signupVC.modalPresentationStyle = .formSheet
          present(signupVC, animated: true, completion: nil)
      }
    
    
    //MARK: Regular VC functions
    private func setupSubViews() {
          setupPursuitGramLogo()
          setupCreateAccountButton()
          setupLoginStack()
      }
     
    private func handleLoginResponse(with result: Result<(), Error>) {
        switch result {
        case .failure(let error):
            showAlert(title: "Error", message: "Could not log in. Error: \(error)")
        case .success:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                else {
                    //MARK: TODO - handle could not swap root view controller
                    return
            }
            //MARK: TODO - refactor this logic into scene delegate
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                window.rootViewController = PursuitGramTabBarVC()
            }, completion: nil)
        }
    }
    
private func showAlert(title: String, message: String) {
       let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
       alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
       present(alertVC, animated: true)
   }
        
    //MARK: - UI Constraints
    private func setupPursuitGramLogo() {
         view.addSubview(pursuitGramLogo)
         pursuitGramLogo.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             pursuitGramLogo.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60),
             pursuitGramLogo.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
             pursuitGramLogo.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16)])
     }

    private func setupLoginStack() {
         let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField,loginButton])
         stackView.axis = .vertical
         stackView.spacing = 15
         stackView.distribution = .fillEqually
         self.view.addSubview(stackView)
         stackView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             stackView.bottomAnchor.constraint(equalTo: createAccount.topAnchor, constant: -50),
             stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
             stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
             stackView.heightAnchor.constraint(equalToConstant: 130)])
     }
    private func setupCreateAccountButton() {
        view.addSubview(createAccount)
        createAccount.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createAccount.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createAccount.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            createAccount.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createAccount.heightAnchor.constraint(equalToConstant: 50)])
    }
}
