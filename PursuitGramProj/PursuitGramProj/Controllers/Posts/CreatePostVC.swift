//
//  CreatePostVC.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/23/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class CreatePostVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    lazy var postImage: UIImageView = {
      let image = UIImageView()
        image.image = UIImage(systemName: "camera")
     return image
    }()
    lazy var imageLibrary: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("pick", for: .normal)
        return button
    }()
    lazy var shareButton: UIBarButtonItem = {
            let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(shareAction))
           return button
       }()
       
    @objc private func addImagePressed(){
         switch PHPhotoLibrary.authorizationStatus(){
         case .notDetermined, .denied , .restricted:
             PHPhotoLibrary.requestAuthorization({[weak self] status in
                 switch status {
                 case .authorized:
                     self?.presentPhotoPickerController()
                 case .denied:
                     print("Denied photo library permissions")
                 default:
                     print("No usable status")
                 }
             })
         default:
             presentPhotoPickerController()
         }
     }
    
    
       @objc func shareAction(){
        
       }
    private func setupViews(){
        view.backgroundColor = .white
        setupImageView()
        setupLibraryButton()
        self.navigationItem.rightBarButtonItem = shareButton
    }
    private func setupImageView() {
           view.addSubview(postImage)
           postImage.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               postImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
               postImage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
               postImage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
             postImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.60)])
      
       }
    private func setupLibraryButton() {
             view.addSubview(imageLibrary)
             imageLibrary.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 imageLibrary.topAnchor.constraint(equalTo: self.postImage.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                 imageLibrary.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
                 imageLibrary.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
                 imageLibrary.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
             
             ])
        
         }
    
}
