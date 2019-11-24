//
//  PursuitGramTabBarVC.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/19/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class PursuitGramTabBarVC: UITabBarController {

    lazy var postsVC: UINavigationController = {
        let postVC = FeedVc()
        postVC.user = AppUser(from: FirebaseAuthService.manager.currentUser!)
        return UINavigationController(rootViewController: postVC)
    }()
    lazy var addPostVC: UINavigationController = {
        let add = CreatePostVC()
        add.user = AppUser(from: FirebaseAuthService.manager.currentUser!)
        return UINavigationController(rootViewController: add)
    }()
      lazy var profileVC: UINavigationController = {
          let userProfileVC = UserProfileVc()
           userProfileVC.user = AppUser(from: FirebaseAuthService.manager.currentUser!)
           userProfileVC.isCurrentUser = true
          return UINavigationController(rootViewController: userProfileVC)
      }()
    override func viewDidLoad() {
        super.viewDidLoad()
        addPostVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "camera"), tag: 0)
        postsVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.dash"), tag: 0)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.square"), tag: 2)
        self.viewControllers = [postsVC,addPostVC,profileVC]
    }
    

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */

}
