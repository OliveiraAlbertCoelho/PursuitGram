//
//  CreatePostVC.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/23/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit
import Photos
class CreatePostVC: UIViewController {
    var imageURL: URL? = nil
    var image = UIImage() {
           didSet {
               self.postImage.image = image
           }
       }
       
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
        button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
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
    
    private func presentPhotoPickerController() {
          DispatchQueue.main.async{
              let imagePickerViewController = UIImagePickerController()
              imagePickerViewController.delegate = self
              imagePickerViewController.sourceType = .photoLibrary
              imagePickerViewController.allowsEditing = true
              imagePickerViewController.mediaTypes = ["public.image"]
              self.present(imagePickerViewController, animated: true, completion: nil)
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
extension CreatePostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           guard let image = info[.editedImage] as? UIImage else {
               return
           }
           self.image = image
           guard let imageData = image.jpegData(compressionQuality: 1) else {
               return
           }
           
           FirebaseStorage.manager.storeImage(image: imageData, completion: { [weak self] (result) in
               switch result{
               case .success(let url):
                   //Note - defer UI response, update user image url in auth and in firestore when save is pressed
                   self?.imageURL = url
                   print("ahhh")
               case .failure(let error):
                   //MARK: TODO - defer image not save alert, try again later. maybe make VC "dirty" to allow user to move on in nav stack
                   print(error)
               }
           })
           dismiss(animated: true, completion: nil)
       }
}
