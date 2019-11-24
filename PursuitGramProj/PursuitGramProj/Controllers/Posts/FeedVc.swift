//
//  FeedVC.swift
//  
//
//  Created by albert coelho oliveira on 11/23/19.
//

import UIKit

class FeedVc: UIViewController {
    
    var posts = [Post](){
        didSet{
            postCollectionView.reloadData()
        }
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getPosts()
    }
    //MARK: Variables
    var user: AppUser?
    
    //MARK: - UI Objects
    lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(PostsCell.self, forCellWithReuseIdentifier: "posts")
        cv.isScrollEnabled = true
        cv.backgroundColor = .gray
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    lazy var feedLabel: UILabel = {
        let label = UILabel()
        label.text = "Feed"
        label.backgroundColor = .gray
        return label
    }()
    
    //MARK: Regular functions
    private func setUpView(){
        view.backgroundColor = .white
        constrainFeedLabel()
        constrainCollectionView()
    }
    private func getPosts(){
        
        FirestoreService.manager.getAllPost { (result) in
            DispatchQueue.main.async {
                
            
            switch result{
            case .failure(let error):
                print(error)
            case .success(let data):
                
                self.posts = data.filter { (selec) -> Bool in
                    return selec.creatorID != self.user!.uid
                    
                }
                    
                }
                
            }
        }}
    
    
    
    //MARK: - Constraints
    private func constrainFeedLabel(){
           view.addSubview(feedLabel)
           feedLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               feedLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
               feedLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
               feedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
               feedLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10)
           ])
       }
    private func constrainCollectionView(){
        view.addSubview(postCollectionView)
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            postCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            postCollectionView.topAnchor.constraint(equalTo: feedLabel.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            postCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
   
    
}
extension FeedVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "posts", for: indexPath) as? PostsCell
        let data = posts[indexPath.row]
        DispatchQueue.main.async {
            FirebaseStorage.postManager.getImages(profileUrl: data.imageUrl!) { (result) in
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let image):
                    cell?.postImage.image = UIImage(data: image, scale: 40)
                    
                }
            }
        }
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 137, height: 137)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
