//
//  editUserProfileVC.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/22/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit
import Photos

class EditUserProfileVC: UIViewController {
    //MARK: lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    //MARK: Variables
    var image: UIImage! {
        didSet {
            self.profileImage.image = image
        }
    }
    
    //MARK: UI Objects
    lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont(name: "Verdana-Bold", size: 40)
        label.textColor = #colorLiteral(red: 0.2481059134, green: 0.430631876, blue: 0.7893758416, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.image = UIImage(systemName: "person")
        image.layer.cornerRadius = 15
        
        return image
    }()
    lazy var userName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please enter userName"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .white
        textField.borderStyle = .bezel
        textField.layer.cornerRadius = 30
        textField.autocorrectionType = .no
        textField.delegate = self
        return textField
    }()
    lazy var addImage: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = #colorLiteral(red: 0.2512508333, green: 0.4225369692, blue: 0.7813953161, alpha: 1)
        button.layer.cornerRadius = 30
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2.0
        button.layer.shadowColor = UIColor.yellow.cgColor
        
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
        return button
    }()
    lazy var saveProfile: UIButton = {
        let button = UIButton()
        button.setTitle("Save Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 14)
        button.backgroundColor = #colorLiteral(red: 0.2563059926, green: 0.4384370148, blue: 0.8014467359, alpha: 1)
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        return button
    }()
    //MARK: - Objc funcs
    @objc private func savePressed(){
        guard let userInfo = userName.text else {
            return showAlert(title: "", message: "Please type a username")
        }
        if userInfo.isEmpty{
            showAlert(title: "", message: "Please type a username")
        }else {
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                return
            }
            FirebaseStorage.profilemanager.storeImage(image: imageData, completion: { [weak self] (result) in
                switch result{
                case .success(let url):
                    
                    FirebaseAuthService.manager.updateUserFields(userName: userInfo, photoURL: url) { (result) in
                        switch result{
                        case .success():
                            FirestoreService.manager.updateCurrentUser(userName: userInfo, photoURL: url) { [weak self] (newResult) in
                                switch newResult {
                                case .success():
                                    self?.navigationController?.popViewController(animated: true)
                                    
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }}
    
    
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
    //MARK: - Regular funcs
    private func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true)
    }
    private  func  presentPhotoPickerController() {
        DispatchQueue.main.async{
            let imagePickerViewController = UIImagePickerController()
            imagePickerViewController.delegate = self
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.allowsEditing = true
            imagePickerViewController.mediaTypes = ["public.image"]
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
    }
    private func addViews(){
        view.backgroundColor = #colorLiteral(red: 0.4043477178, green: 0.7694571614, blue: 0.7561989427, alpha: 1)
        constrainProfileLabel()
        constrainImageView()
        constrainAddImageButton()
        constrainUserName()
        constrainSaveButton()
    }
    //MARK: - UI Constraints
    
    private func constrainProfileLabel() {
        view.addSubview(profileLabel)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileLabel.heightAnchor.constraint(equalToConstant: 50)])
    }
    private func constrainImageView() {
        view.addSubview(profileImage)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            profileImage.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 200),
            profileImage.widthAnchor.constraint(equalToConstant: 200)])
    }
    private func constrainAddImageButton(){
        view.addSubview(addImage)
        addImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addImage.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: -40),
            addImage.bottomAnchor.constraint(equalTo: profileImage.topAnchor, constant: 40),
            addImage.heightAnchor.constraint(equalToConstant: 60),
            addImage.widthAnchor.constraint(equalToConstant: 60)])
        
    }
    private func constrainUserName(){
        view.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            userName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 40),
            userName.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    private func constrainSaveButton(){
        view.addSubview(saveProfile)
        saveProfile.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveProfile.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            saveProfile.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            saveProfile.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 40),
            saveProfile.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
}
//MARK: - UiImagePicker
extension EditUserProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.image = image
        dismiss(animated: true, completion: nil)
    }
}
extension EditUserProfileVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
