//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Aleksandr on 07.08.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var avatarImageView: UIImageView!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP Black") ?? .black
        
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        setupAvatarImageView()
        setupNameLabel()
        setupLoginNameLabel()
        setupDescriptionLabel()
        setupLogoutButton()
    }

    private func setupAvatarImageView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AvatarPhoto") ?? UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
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
        label.textColor = .white
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
        label.textColor = .gray
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
        label.textColor = .white
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
        let buttonImage = UIImage(named: "logoutButton") ?? UIImage()
        let button = UIButton.systemButton(with: buttonImage, target: self, action: #selector(didTapLogoutButton))
        button.tintColor = UIColor(named: "YP Red") ?? .red
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        self.logoutButton = button
    }

    // MARK: - Actions

    @objc private func didTapLogoutButton() {

    }
}
