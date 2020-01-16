//
//  ProfileViewController.swift
//  Lamstagram
//
//  Created by Jan Kaltoun on 12/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var viewModel: ProfileViewModel!
    
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
        
        viewModel.delegate = self
        viewModel.getUser()
    }
    
    func reloadData() {
        navigationItem.title = viewModel.user?.name
        
        mainCollectionView.reloadData()
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch self.viewModel.getSection(for: sectionIndex) {
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
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNumberOfItems(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.getSection(for: indexPath.section) {
        case .profile:
            let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            
            if let user = viewModel.user {
                let cellViewModel = ProfileHeaderCellViewModel(user: user)
                cell.viewModel = cellViewModel
            }
            
            return cell
        case .friends:
            let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFriendCell", for: indexPath) as! ProfileFriendCell
            
            if let friend = viewModel.getFriend(for: indexPath.row) {
                let cellViewModel = ProfileFriendCellViewModel(user: friend)
                cell.viewModel = cellViewModel
            }
            
            return cell
        case .photos:
            let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePhotoCell", for: indexPath) as! ProfilePhotoCell
            
            if let post = viewModel.getPost(for: indexPath.row) {
                let cellViewModel = ProfilePhotoCellViewModel(post: post)
                cell.viewModel = cellViewModel
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.getSection(for: indexPath.section) {
        case .friends:
            guard let friends = viewModel.user?.friends else {
                break
            }
            
            let friend = friends[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = storyboard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
            
            let profileViewModel = ProfileViewModel(
                userService: UserService(
                    apiManager: APIManager()
                )
            )
            profileViewModel.userID = friend.id
            
            profileViewController.viewModel = profileViewModel
            
            navigationController?.pushViewController(profileViewController, animated: true)
        case .photos:
            guard let post = viewModel.user?.posts?[indexPath.row] else {
                break
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let photoDetailViewController = storyboard.instantiateViewController(identifier: "PhotoDetailViewController") { coder -> UIViewController? in
                let viewModel = PhotoDetailViewModel()
                let viewController = PhotoDetailViewController(coder: coder, viewModel: viewModel)
                
                viewModel.photoName = post.imageName
                
                return viewController
            }
            
            present(photoDetailViewController, animated: true)
        case .profile:
            break
        }
    }
}

extension ProfileViewController: ProfileViewModelDelegate {
    func stateDidChange(previousState: State) {
        switch viewModel.state {
        case .ready:
            reloadData()
        case .failed(let error):
            print(error)
        default:
            break
        }
    }
}
