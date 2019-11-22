//
//  editUserProfileVC.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/22/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class EditUserProfileVC: UIViewController {
    var settingFromLogin = false
    var imageURL: URL? = nil
    var isCurrentUser = false
    
    var image = UIImage() {
           didSet {
               self.profileImage.image = image
           }
       }
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
    }
    //MARK: UI Objects
    lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont(name: "Verdana-Bold", size: 40)
        label.textColor = UIColor(red: 255/255, green: 86/255, blue: 0/255, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    lazy var profileImage: UIImageView = {
          let image = UIImageView()
           image.backgroundColor = .gray
           image.image = UIImage(systemName: "person")
            image.layer.cornerRadius = 15
           return image
       }()
       lazy var userName: UITextField = {
           let textField = UITextField()
           textField.placeholder = "Please enter userName"
           textField.font = UIFont(name: "Verdana", size: 14)
           textField.backgroundColor = .white
           textField.borderStyle = .bezel
           textField.layer.cornerRadius = 15
           textField.autocorrectionType = .no
           return textField
       }()
    lazy var addImage: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 30
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2.0
        button.layer.shadowColor = UIColor.yellow.cgColor
        button.clipsToBounds = true
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
    //MARK: - Objc funcs
    @objc private func savePressed(){
        guard let userText = userName.text, let imageURL = imageURL else {
            return
        }
        FirebaseAuthService.manager.updateUserFields(userName: userText, photoURL: imageURL) { (result) in
            switch result{
            case .success():
                FirestoreService.manager.updateCurrentUser { [weak self] (newResult) in
                    switch newResult {
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
        }
        
    }
    }
    
    private func handleNavigationAwayFromVC() {
          if settingFromLogin {
              //MARK: TODO - refactor this logic into scene delegate
              guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                  else {
                      //MARK: TODO - handle could not swap root view controller
                      return
              }
              UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                  window.rootViewController = RedditTabBarViewController()
              }, completion: nil)
          } else {
              self.navigationController?.popViewController(animated: true)
          }
      }
    
    //MARK: - UI Constraints
    private func addViews(){
        constrainProfileLabel()
        constrainImageView()
        constrainAddImageButton()
        constrainUserName()
    }
    private func constrainProfileLabel() {
        view.addSubview(profileLabel)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileLabel.heightAnchor.constraint(equalToConstant: 50)])
    }
    private func constrainImageView() {
           view.addSubview(profileImage)
                  profileImage.translatesAutoresizingMaskIntoConstraints = false
                  NSLayoutConstraint.activate([
                      profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
                      profileImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
                      profileImage.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 100),
                      profileImage.heightAnchor.constraint(equalToConstant: 200),
                      profileImage.widthAnchor.constraint(equalToConstant: 200)])
       }
    private func constrainAddImageButton(){
        view.addSubview(addImage)
          addImage.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
            addImage.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: -40),
              addImage.bottomAnchor.constraint(equalTo: profileImage.topAnchor, constant: 40),
              addImage.heightAnchor.constraint(equalToConstant: 60),
              addImage.widthAnchor.constraint(equalToConstant: 60)])
            
    }
    private func constrainUserName(){
          view.addSubview(userName)
            userName.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
              userName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
              userName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
              userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 40),
                userName.heightAnchor.constraint(equalToConstant: 40),
               ])
      }
   
}
