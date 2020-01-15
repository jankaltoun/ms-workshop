//
//  TabBarController.swift
//  Lamstagram
//
//  Created by Jan Kaltoun on 12/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let feedNavigationController = UINavigationController()
        
        let feedViewController = storyboard.instantiateViewController(identifier: "FeedViewController") as! FeedViewController
        feedViewController.tabBarItem.image = UIImage(systemName: "house")
        feedViewController.tabBarItem.title = "Feed"
        
        feedNavigationController.pushViewController(feedViewController, animated: false)
        
        let profileNavigationController = UINavigationController()
        
        let profileViewController = storyboard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        profileViewController.tabBarItem.image = UIImage(systemName: "person")
        profileViewController.tabBarItem.title = "Profile"
        profileViewController.userID = 1
        
        profileNavigationController.pushViewController(profileViewController, animated: false)
        
        viewControllers = [
            feedNavigationController,
            profileNavigationController
        ]
    }
}

