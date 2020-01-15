//
//  ProfileViewController.swift
//  Lamstagram
//
//  Created by Jan Kaltoun on 12/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    enum Section: Int {
        case profile
        case friends
        case photos
    }
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var userID: Int?
    var user: User?
    
    var sections: [Section] {
        var sections = [Section]()
        
        sections.append(.profile)
        
        if user?.friends?.isEmpty == false {
            sections.append(.friends)
        }
        
        if user?.posts?.isEmpty == false {
            sections.append(.photos)
        }
        
        return sections
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileCellNib = UINib(nibName: "ProfileHeaderCell", bundle: Bundle.main)
        mainCollectionView.register(profileCellNib, forCellWithReuseIdentifier: "ProfileHeaderCell")
        
        let friendCellNib = UINib(nibName: "ProfileFriendCell", bundle: Bundle.main)
        mainCollectionView.register(friendCellNib, forCellWithReuseIdentifier: "ProfileFriendCell")
        
        let photoCellNib = UINib(nibName: "ProfilePhotoCell", bundle: Bundle.main)
        mainCollectionView.register(photoCellNib, forCellWithReuseIdentifier: "ProfilePhotoCell")
        
        let layout = createLayout()
        
        mainCollectionView.collectionViewLayout = layout
        
        getUser()
    }
    
    func reloadData() {
        navigationItem.title = user?.name
        
        mainCollectionView.reloadData()
    }
    
    func getUser() {
        APIManager.current.request(path: "users") { [weak self] userData in
            guard let self = self else {
                return
            }
            
            let decoder = JSONDecoder()
            
            if let fetchedUsers = try? decoder.decode([User].self, from: userData) {
                self.user = fetchedUsers.filter { $0.id == self.userID! }.first
            }
            
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch self.sections[sectionIndex] {
            case .profile:
                return self.createProfileHeaderSection()
            case .friends:
                return self.createFriendsSection()
            case .photos:
                return self.createPhotosSection()
            }
        }
    }
    
    func createProfileHeaderSection() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(150)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return section
    }
    
    func createFriendsSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .absolute(60),
            heightDimension: .absolute(80)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return section
    }
    
    func createPhotosSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1/3)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)

        return section
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .profile:
            return 1
        case .friends:
            return user?.friends?.count ?? 0
        case .photos:
            return user?.posts?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .profile:
            let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            
            if let user = user {
                cell.profilePhotoImageView.image = UIImage(named: user.imageName)
                cell.numberOfPostsLabel.text = String(user.numberOfPosts)
                cell.numberOfFollowedLabel.text = String(user.numberFollowing)
                cell.numberOfFollowersLabel.text = String(user.numberOfFollowers)
                cell.descriptionLabel.text = user.description
            }
            
            return cell
        case .friends:
            let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFriendCell", for: indexPath) as! ProfileFriendCell
            
            if let friends = user?.friends {
                let friend = friends[indexPath.row]
                
                cell.profileImageView.image = UIImage(named: friend.imageName)
                cell.nicknameLabel.text = friend.nickname
            }
            
            return cell
        case .photos:
            let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePhotoCell", for: indexPath) as! ProfilePhotoCell
            
            if let posts = user?.posts {
                let post = posts[indexPath.row]
                
                cell.photoImageView.image = UIImage(named: post.imageName)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .friends:
            guard let friends = user?.friends else {
                break
            }
            
            let friend = friends[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = storyboard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
            profileViewController.userID = friend.id
            
            navigationController?.pushViewController(profileViewController, animated: true)
        case .photos:
            guard let post = user?.posts?[indexPath.row] else {
                break
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let photoDetailViewController = storyboard.instantiateViewController(identifier: "PhotoDetailViewController") as! PhotoDetailViewController
            photoDetailViewController.photo = UIImage(named: post.imageName)
            
            present(photoDetailViewController, animated: true)
        case .profile:
            break
        }
    }
}
