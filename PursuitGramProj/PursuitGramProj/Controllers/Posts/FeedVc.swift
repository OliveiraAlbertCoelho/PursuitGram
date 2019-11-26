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
    var users = [AppUser]()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getPosts()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK: Variables
    var user: AppUser?
    
    //MARK: - UI Objects
    lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(FeedCell.self, forCellWithReuseIdentifier: "feed")
        cv.isScrollEnabled = true
        cv.backgroundColor =  #colorLiteral(red: 0.2564295232, green: 0.4383472204, blue: 0.8055806756, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    lazy var feedLabel: UILabel = {
        let label = UILabel()
        label.text = "Pursuitsgram"
        label.textAlignment = .center
        label.font = UIFont(name: "Verdana-Bold", size: 40)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0.4001295269, green: 0.7655242085, blue: 0.7522726655, alpha: 1)
        return label
    }()
    
    //MARK: Regular functions
    private func setUpView(){
        view.backgroundColor = #colorLiteral(red: 0.2564295232, green: 0.4383472204, blue: 0.8055806756, alpha: 1)
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
            postCollectionView.topAnchor.constraint(equalTo: feedLabel.safeAreaLayoutGuide.bottomAnchor, constant: 15),
            postCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
   
    
}
extension FeedVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "feed", for: indexPath) as? FeedCell
        let data = posts[indexPath.row]
        if let userUrl = data.imageUrl{
            FirebaseStorage.postManager.getImages(profileUrl: userUrl) { (result) in
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let image):
                    cell?.postImage.image = UIImage(data: image, scale: 40)
                }}
                    FirestoreService.manager.getUserFromPost(creatorID: data.creatorID) { (result) in
                        DispatchQueue.main.async {
                        switch result{
                        case .failure(let error):
                            print(error)
                        case .success(let user):
                            cell?.userNameLabel.text = user.userName ?? " "
                            self.users.append(user)
                            }
                        }
            }}
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 300)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        let detail = PostDetailVC()
        detail.post = post
        detail.user = user
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
