//
//  editUserProfileVC.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/22/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class EditUserProfileVC: UIViewController {
    var user: AppUser!
       var isCurrentUser = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
    }
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
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 30
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
    
    
    //MARK: - UI Constraints
    private func addViews(){
        constrainProfileLabel()
        constrainAddImageButton()
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
                      profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 180),
                      profileImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -180),
                      profileImage.topAnchor.constraint(equalTo: profileLabel.safeAreaLayoutGuide.bottomAnchor),
                      profileImage.heightAnchor.constraint(equalToConstant: 60),
                      profileImage.widthAnchor.constraint(equalToConstant: 60)])
       }
    private func constrainAddImageButton(){
        view.addSubview(addImage)
          addImage.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              addImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 180),
              addImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -180),
              addImage.topAnchor.constraint(equalTo: profileLabel.safeAreaLayoutGuide.bottomAnchor),
              addImage.heightAnchor.constraint(equalToConstant: 60),
              addImage.widthAnchor.constraint(equalToConstant: 60)])
            
    }
   
}
