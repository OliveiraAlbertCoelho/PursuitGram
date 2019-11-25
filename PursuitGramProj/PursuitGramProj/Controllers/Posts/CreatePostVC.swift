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
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

    }
    //MARK: - Regular variables
    let imagePickerViewController = UIImagePickerController()
    var imageURL: URL? = nil
    var user: AppUser!
    var image = UIImage() {
        didSet {
            self.postImage.image = image
        }
    }
    //MARK: - Ui Objects
    lazy var postImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "camera")
        image.backgroundColor = #colorLiteral(red: 0.2481059134, green: 0.430631876, blue: 0.7893758416, alpha: 1)
        image.tintColor = .black
        image.contentMode = .scaleToFill
        return image
    }()
    lazy var imageLibrary: UIButton = {
        let button = UIButton()
        button.backgroundColor =  #colorLiteral(red: 0.2481059134, green: 0.430631876, blue: 0.7893758416, alpha: 1)
        button.setTitle("Library", for: .normal)
        button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
        return button
        
    }()
    lazy var shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(shareAction))
        return button
    }()
    
    
    
    
    //MARK: - Objc functions
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
    
    @objc private func shareAction(){
        
        shareButton.isEnabled = false
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            showAlert(title: "", message: "Please select a image")
            shareButton.isEnabled = true
            return
        }
        FirebaseStorage.postManager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url):
              self?.tabBarController?.selectedIndex = 2
              let post = Post(creatorID: self!.user.uid, dateCreated: nil, imageUrl: url.absoluteString )
                       FirestoreService.manager.createPost(post: post) { (result) in
                           switch result{
                           case .success(()):
                            self!.postImage.image = UIImage(systemName: "camera")
                           case .failure(let error):
                               print(error)
                           }
                       }
            case .failure(let error):
                self?.showAlert(title: "", message: "Please retry to save Image")
                self!.shareButton.isEnabled = true
                print(error)
            }
        })
       
        
       
    }
    
    //MARK: - Regular functions
    private func setupViews(){
        view.backgroundColor = .black
        setupImageView()
        setupLibraryButton()
        self.navigationItem.rightBarButtonItem = shareButton
    }
    private func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
    private func presentPhotoPickerController() {
        self.imagePickerViewController.delegate = self
        self.imagePickerViewController.sourceType = .photoLibrary
        self.imagePickerViewController.allowsEditing = true
        self.imagePickerViewController.mediaTypes = ["public.image"]
        self.present(self.imagePickerViewController, animated: true, completion: nil)
    }
    //MARK: - Constraints
    private func setupImageView() {
        view.addSubview(postImage)
        postImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            postImage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            postImage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            postImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40)])
        
    }
    private func setupLibraryButton() {
        view.addSubview(imageLibrary)
        imageLibrary.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageLibrary.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            imageLibrary.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            imageLibrary.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            imageLibrary.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10)
            
        ])
        
    }
    
}
//MARK: - UIImagePIcker
extension CreatePostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.image = image
        dismiss(animated: true, completion: nil)
    }
}
