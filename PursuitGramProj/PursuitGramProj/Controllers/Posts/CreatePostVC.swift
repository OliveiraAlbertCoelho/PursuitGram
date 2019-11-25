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
    
    var images = [UIImage](){
        didSet{
            postCollectionView.reloadData()
        }
    }
       override func viewDidLoad() {
           super.viewDidLoad()
           setupViews()
         getImages()
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
    func getImages() {
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        assets.enumerateObjects({ (object, count, stop) in
        self.images.append(self.getUIImage(asset: object)!)
        })
        self.images.reverse()
    }
   
    //MARK: - Ui Objects
    lazy var postImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "camera")
        image.sizeToFit()
        image.backgroundColor = .black
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
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(shareAction))
        return button
    }()
    lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(PostsCell.self, forCellWithReuseIdentifier: "posts")
        cv.isScrollEnabled = true
        cv.backgroundColor = .cyan
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    //MARK: - Objc functions
    @objc private func addImagePressed(){
        switch PHPhotoLibrary.authorizationStatus(){
        case .notDetermined, .denied , .restricted:
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                switch status {
                case .authorized:
                    self!.getImages()
                case .denied:
                    print("Denied photo library permissions")
                default:
                    print("No usable status")
                }
            })
        default:
            self.getImages()
        }
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    @objc private func shareAction(){
       guard let userImage = postImage.image
        else{ return }
        userImage.resizableImage(withCapInsets: UIEdgeInsets(top: 300, left: 300, bottom: 300, right: 300))
            guard let imageData = userImage.jpegData(compressionQuality: 0.10) else {
                   return
               }
        FirebaseStorage.postManager.storeImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url):
                self?.imageURL = url
            case .failure(let error):
                self?.showAlert(title: "", message: "Please retry to save Image")
                print(error)
            }
        })
        guard let image = imageURL?.absoluteString, let currentUser = user?.uid else{
                  return showAlert(title: "", message: "Please pick a image")
              }
        
        let post = Post(creatorID: currentUser , dateCreated: nil, imageUrl: image )
        FirestoreService.manager.createPost(post: post) { (result) in
            switch result{
            case .success(()):
                let userProfile = UserProfileVc()
                userProfile.user = self.user
                self.navigationController?.pushViewController(userProfile, animated: true)
            case .failure(let error):
                print(error)
            }
            }}
    
    //MARK: - Regular functions
    private func setupViews(){
        view.backgroundColor = .black
        setupImageView()
        setupCollectionView()
        self.navigationItem.rightBarButtonItem = shareButton
    }
     private func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
  
    //MARK: - Constraints
    private func setupImageView() {
        view.addSubview(postImage)
        postImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            postImage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            postImage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            postImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.50)])
        
    }
   
    private func setupCollectionView() {
          view.addSubview(postCollectionView)
          postCollectionView.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              postCollectionView.topAnchor.constraint(equalTo: self.postImage.safeAreaLayoutGuide.bottomAnchor, constant: 30),
              postCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
              postCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
              postCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
              
          ])
          
      }
    
}
extension CreatePostVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "posts", for: indexPath) as? PostsCell
        let data = images[indexPath.row]
        cell?.postImage.image = data
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pickedImage = images[indexPath.row]
        postImage.image = pickedImage
        
    }
}

