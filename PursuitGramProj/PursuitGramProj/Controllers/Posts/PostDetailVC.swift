//
//  UserPostDetailVC.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/22/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class PostDetailVC: UIViewController {

    //MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
        setUpView()
        print(post!.dateFormat)
    }
    //MARK: - Variables
    var post: Post?
    var user: AppUser?
    var iscurrentUSer = false
    
    //MARK: - UI Objects
    lazy var postImage: UIImageView = {
    let view = UIImageView()
    view.backgroundColor = .blue
        view.contentMode = .scaleToFill
    return view
    }()
    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.text = user?.userName
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        return label
    }()
    lazy var dateLabel: UILabel = {
         let label = UILabel()
         label.text = post?.dateFormat
        label.font =  UIFont.systemFont(ofSize: 10.0)
         return label
     }()
     
    
    //MARK: - Regular functions
    private func setUpView(){
        view.backgroundColor = #colorLiteral(red: 0.4001295269, green: 0.7655242085, blue: 0.7522726655, alpha: 1)
        setUpPostImage()
        setUpUserLabel()
        setUpPostDate()
        if iscurrentUSer{
            userLabel.isHidden = true
        }
    }
    
    private func loadPost(){
        guard let postData = post?.imageUrl else{
            return print("error")
    }
        FirebaseStorage.postManager.getImages(profileUrl: postData) { (result) in
            DispatchQueue.main.async {
            switch result{
            case .success(let data):
                self.postImage.image = UIImage(data: data)
            case .failure(let error):
                print(error)
                }
            }
        }
    }
        
    //MARK: - Constraints
    private func setUpPostImage() {
           view.addSubview(postImage)
           postImage.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               postImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
               postImage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
               postImage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
               postImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.70)
           ])
           
       }
    private func setUpUserLabel() {
            view.addSubview(userLabel)
            userLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                userLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                userLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
                userLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
                userLabel.topAnchor.constraint(equalTo: self.postImage.bottomAnchor, constant: 10)
            ])
        }
    private func setUpPostDate() {
              view.addSubview(dateLabel)
              dateLabel.translatesAutoresizingMaskIntoConstraints = false
              NSLayoutConstraint.activate([
                dateLabel.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 0),
                  dateLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
                  dateLabel.heightAnchor.constraint(equalToConstant: 30),
                  dateLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
                
              ])
          }
   
    
}
