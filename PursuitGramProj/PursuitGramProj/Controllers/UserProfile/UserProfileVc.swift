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
        view.backgroundColor = .white
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        setUpView()

    }
  
    
    lazy var profileImage: UIImageView = {
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
        label.textAlignment = .center
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.addTarget(self, action: #selector(editAction), for: .touchUpInside)
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
    @objc private func editAction(){
    }
    private func setUpView(){
        constrainProfileImage()
          constrainTotalPost()
        constrainUserName()

        constrainCollectionView()
      
    }

    
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
            userName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 50),
            userName.heightAnchor.constraint(equalToConstant: 30),
            userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            userName.widthAnchor.constraint(equalToConstant: 150)
      ])
    }
    private func constrainCollectionView(){
        view.addSubview(postCollectionView)
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            postCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            postCollectionView.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 0),
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
        print(collectionView.contentSize.height)
        return CGSize(width: 137, height: 137)
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
   
    
}
