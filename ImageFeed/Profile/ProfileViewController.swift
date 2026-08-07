//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Aleksandr on 07.08.2026.
//

import UIKit

final class ProfileViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func LogoutButtonCliced(_ sender: UIButton) {
    }
    
    
}
