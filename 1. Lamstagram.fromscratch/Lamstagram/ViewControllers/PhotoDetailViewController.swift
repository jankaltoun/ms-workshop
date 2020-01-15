//
//  PhotoDetailViewController.swift
//  Lamstagram
//
//  Created by Jan Kaltoun on 13/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.image = photo
    }
}
