//
//  UserProfileVc.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/21/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class UserProfileVc: UIViewController {
    var user: AppUser!
    var isCurrentUser = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        setUpView()
        loadProfileImage()
        navigationItem.rightBarButtonItem = logOutButton
    }
    
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        if let photo = user.photoURL{
            image.image = UIImage(contentsOfFile: (photo))
        }else {
            image.image = UIImage(systemName: "person")
        }
        
        image.layer.cornerRadius = 15
        return image
    }()
    lazy var userName: UILabel = {
        let label = UILabel()
        
        label.text = user.userName ?? "User not found"
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    lazy var totalPost: UILabel = {
        let label = UILabel()
        label.text = "0 \n Posts"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    lazy var logOutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(logOut))
        return button
    }()
    
    @objc func logOut (){
        DispatchQueue.main.async {
            FirebaseAuthService.manager.logOut { (result) in
                
            }
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                else {
                    return
            }
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                window.rootViewController = UserLoginVC()
            }, completion: nil)
        }
    }
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit profile", for: .normal)
        button.tintColor = .orange
        button.backgroundColor = .black
        button.isHidden = true
        button.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        if isCurrentUser {
            button.isHidden = false
        }
        return button
    }()
    
    lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(PostsCell.self, forCellWithReuseIdentifier: "posts")
        cv.backgroundColor = .gray
        return cv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        user = AppUser(from: FirebaseAuthService.manager.currentUser!)
        loadProfileImage()
    }
    
    
    @objc private func editAction(){
        let editVC = EditUserProfileVC()
        editVC.profileImage.image = profileImage.image
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    private func setUpView(){
        constrainProfileImage()
        constrainTotalPost()
        constrainUserName()
        constrainEditButton()
        constrainCollectionView()
    }
    
    private func loadProfileImage(){
        self.userName.text = self.user.userName
        guard let photo = self.user.photoURL else {
           return
        }
        DispatchQueue.main.async {
            FirebaseStorage.profilemanager.getProfileImage(profileUrl: photo) { (result) in
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let data):
                    self.profileImage.image = UIImage(data: data)
                }
            }
        }}
    
    
    
    private func constrainProfileImage(){
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImage.widthAnchor.constraint(equalToConstant: 150)
            
        ])
    }
    private func constrainTotalPost(){
        view.addSubview(totalPost)
        totalPost.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalPost.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 50),
            totalPost.heightAnchor.constraint(equalToConstant: 60),
            totalPost.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 10),
            totalPost.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    private func constrainUserName(){
        view.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 0),
            userName.heightAnchor.constraint(equalToConstant: 30),
            userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            userName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    private func constrainEditButton(){
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 0),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5),
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    private func constrainCollectionView(){
        view.addSubview(postCollectionView)
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            postCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            postCollectionView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 60),
            postCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    
}
extension UserProfileVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "posts", for: indexPath) as? PostsCell
        cell?.postImage.image = UIImage(systemName: "plus")
        cell?.backgroundColor = .green
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 137, height: 137)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
