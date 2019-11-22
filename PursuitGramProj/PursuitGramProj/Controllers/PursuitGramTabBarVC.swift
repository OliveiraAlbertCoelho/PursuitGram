//
//  PursuitGramTabBarVC.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/19/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class PursuitGramTabBarVC: UITabBarController {

    lazy var postsVC = UINavigationController(rootViewController: UserPostsVC())
      lazy var profileVC: UINavigationController = {
          let userProfileVC = EditUserProfileVC()
          userProfileVC.user = AppUser(from: FirebaseAuthService.manager.currentUser!)
          userProfileVC.isCurrentUser = true
          return UINavigationController(rootViewController: userProfileVC)
      }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsVC.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(systemName: "list.dash"), tag: 0)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.square"), tag: 2)
        self.viewControllers = [postsVC,profileVC]

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
