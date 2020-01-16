//
//  FeedViewController.swift
//  Lamstagram
//
//  Created by Jan Kaltoun on 12/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var feedTableView: UITableView!
    
    var viewModel: FeedViewModel
    
    init?(coder: NSCoder, viewModel: FeedViewModel) {
        self.viewModel = viewModel
        
        super.init(coder: coder)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a ViewModel.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        feedTableView.contentInsetAdjustmentBehavior = .never
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: Bundle.main)
        feedTableView.register(cellNib, forCellReuseIdentifier: "PostTableViewCell")
        
        viewModel.getPosts()
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = viewModel.getPost(for: indexPath.row)
        
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        
        if let user = post.user {
            let viewModel = PostCellViewModel(
                user: user,
                photoName: post.imageName
            )
            
            cell.viewModel = viewModel
        }
        
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        feedTableView.deselectRow(at: indexPath, animated: false)
        
        let post = viewModel.getPost(for: indexPath.row)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photoDetailViewController = storyboard.instantiateViewController(identifier: "PhotoDetailViewController") { coder -> UIViewController? in
            let viewModel = PhotoDetailViewModel()
            let viewController = PhotoDetailViewController(coder: coder, viewModel: viewModel)
            
            viewModel.photoName = post.imageName
            
            return viewController
        }
        
        present(photoDetailViewController, animated: true)
    }
}

extension FeedViewController: FeedViewModelDelegate {
    func stateDidChange(previousState: State) {
        switch viewModel.state {
        case .ready:
            feedTableView.reloadData()
        case .failed(let error):
            print(error)
        default:
            break
        }
    }
}
