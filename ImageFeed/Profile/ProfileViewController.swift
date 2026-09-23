//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Aleksandr on 07.08.2026.
//

import UIKit
import Kingfisher

// MARK: - ProfileViewController

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var avatarImageView: UIImageView!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .ypBlack)
        setupUI()
        
        updateProfileDetails(profile: ProfileService.shared.profile)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
        ) { [weak self] _ in
            guard let self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    // MARK: - Actions
    
    @objc private func didTapLogoutButton() {
        // TODO: Обработка нажатия кнопки логаута
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        setupAvatarImageView()
        setupNameLabel()
        setupLoginNameLabel()
        setupDescriptionLabel()
        setupLogoutButton()
    }
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile else { return }
        
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
                else { return }
        
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder.jpeg") ?? UIImage(systemName: "person.crop.circle.fill"),
        )
    }
    
    private func setupAvatarImageView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AvatarPhoto") ?? UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        self.avatarImageView = imageView
    }
    
    private func setupNameLabel() {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = UIColor(resource: .ypWhite)
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
        
        self.nameLabel = label
    }
    
    private func setupLoginNameLabel() {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = UIColor(resource: .ypWhite)
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
        
        self.loginNameLabel = label
    }
    
    private func setupDescriptionLabel() {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = UIColor(resource: .ypWhite)
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor)
        ])
        
        self.descriptionLabel = label
    }
    
    private func setupLogoutButton() {
        let buttonImage = UIImage(resource: .logoutButton)
        let button = UIButton.systemButton(with: buttonImage, target: self, action: #selector(didTapLogoutButton))
        button.tintColor = UIColor(resource: .ypRedIOS)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        self.logoutButton = button
    }
}
