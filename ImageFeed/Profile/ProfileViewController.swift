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
    
    // MARK: - Constants
    
    private enum Constants {
        static let logoutAlertTitle = "Пока, пока!"
        static let logoutAlertMessage = "Уверены, что хотите выйти?"
        static let yesTitle = "Да"
        static let noTitle = "Нет"
        
        static let logoutButtonAccessibilityIdentifier = "logout button"
        static let nameLabelAccessibilityIdentifier = "Name Label"
        static let loginNameLabelAccessibilityIdentifier = "Username Label"
    }
    
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
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapLogoutButton() {
        let alert = UIAlertController(
            title: Constants.logoutAlertTitle,
            message: Constants.logoutAlertMessage,
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(title: Constants.yesTitle, style: .default) { _ in
            ProfileLogoutService.shared.logout()
        }
        
        let noAction = UIAlertAction(title: Constants.noTitle, style: .default)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true)
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
        
        let placeholder = UIImage(resource: .stub)
        avatarImageView.kf.setImage(
            with: url,
            placeholder: placeholder
        )
    }
    
    private func setupAvatarImageView() {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .stub)
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
        label.textColor = UIColor(resource: .ypWhite)
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.accessibilityIdentifier = Constants.nameLabelAccessibilityIdentifier
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
        label.textColor = UIColor(resource: .ypWhite)
        label.font = UIFont.systemFont(ofSize: 13)
        label.accessibilityIdentifier = Constants.loginNameLabelAccessibilityIdentifier
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
        button.accessibilityIdentifier = Constants.logoutButtonAccessibilityIdentifier
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        self.logoutButton = button
    }
}
