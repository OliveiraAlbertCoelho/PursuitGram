//
//  UserPostDetailVC.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/22/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class PostDetailVC: UIViewController {

    var post: Post?
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
        setUpView()
        // Do any additional setup after loading the view.
    }
    //MARK: - Variables
    
    
    
    //MARK: - UI Objects
    lazy var postImage: UIImageView = {
    let view = UIImageView()
    view.backgroundColor = .blue
        view.contentMode = .scaleToFill
    return view
    }()
    
    //MARK: - Regular funcs
    private func setUpView(){
        view.backgroundColor = .white
        setUpPostImage()
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
                }}
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
   
    
}
