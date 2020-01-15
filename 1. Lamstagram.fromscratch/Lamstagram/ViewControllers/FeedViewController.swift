//
//  FeedViewController.swift
//  Lamstagram
//
//  Created by Jan Kaltoun on 12/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var feedTableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        feedTableView.contentInsetAdjustmentBehavior = .never
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: Bundle.main)
        feedTableView.register(cellNib, forCellReuseIdentifier: "PostTableViewCell")
        
        getPosts()
    }
    
    func getPosts() {
        APIManager.current.request(path: "posts") { [weak self] postData in
            guard let self = self else {
                return
            }
            
            let decoder = JSONDecoder()
            
            if let fetchedPosts = try? decoder.decode([Post].self, from: postData) {
                self.posts = fetchedPosts
            }
            
            DispatchQueue.main.async {
                self.feedTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        if let user = post.user {
            cell.userPhotoImageView.image = UIImage(named: user.imageName)
            cell.userNicknameLabel.text = user.nickname
            cell.userNameLabel.text = user.name
        }
        
        cell.photoImageView.image = UIImage(named: post.imageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        feedTableView.deselectRow(at: indexPath, animated: false)
        
        let post = posts[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoDetailViewController = storyboard.instantiateViewController(identifier: "PhotoDetailViewController") as! PhotoDetailViewController
        photoDetailViewController.photo = UIImage(named: post.imageName)
        
        present(photoDetailViewController, animated: true)
    }
}
