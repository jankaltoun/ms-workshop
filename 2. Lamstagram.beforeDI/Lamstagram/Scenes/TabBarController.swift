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
        
        // Using creator
        let feedViewController = storyboard.instantiateViewController(identifier: "FeedViewController") { coder -> UIViewController? in
            let viewModel = FeedViewModel(
                postService: PostService(
                    apiManager: APIManager()
                )
            )
            let viewController = FeedViewController(coder: coder, viewModel: viewModel)
            
            return viewController
        }
        feedViewController.tabBarItem.image = UIImage(systemName: "house")
        feedViewController.tabBarItem.title = "Feed"
        
        feedNavigationController.pushViewController(feedViewController, animated: false)
        
        let profileNavigationController = UINavigationController()
        
        // Without creator
        let profileViewController = storyboard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        profileViewController.tabBarItem.image = UIImage(systemName: "person")
        profileViewController.tabBarItem.title = "Profile"
        
        let profileViewModel = ProfileViewModel(
            userService: UserService(
                apiManager: APIManager()
            )
        )
        profileViewModel.userID = 1
        
        profileViewController.viewModel = profileViewModel
        
        profileNavigationController.pushViewController(profileViewController, animated: false)
        
        viewControllers = [
            feedNavigationController,
            profileNavigationController
        ]
    }
}

