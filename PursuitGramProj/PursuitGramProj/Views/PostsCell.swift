//
//  PostsCell.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/22/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class PostsCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constrainUserName()
        constrainImageView()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var postImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        return image
    }()
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .white
        label.text = "me"
        return label
    }()
    
    private func constrainImageView(){
        contentView.addSubview(postImage)
        postImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            postImage.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            postImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
            postImage.bottomAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: 0)
        ])
    }
    private func constrainUserName(){
          contentView.addSubview(userNameLabel)
          userNameLabel.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              userNameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 0),
              userNameLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: 0),
              userNameLabel.heightAnchor.constraint(equalToConstant: 50),
              userNameLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0)
          ])
      }
    override func prepareForReuse() {
       super.prepareForReuse()
       postImage.image = nil //whatever
    }
}
