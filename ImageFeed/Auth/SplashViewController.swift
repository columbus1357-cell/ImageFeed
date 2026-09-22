//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Aleksandr on 21.08.2026.
//

import UIKit

// MARK: - SplashViewController

final class SplashViewController: UIViewController {

    // MARK: - Private Properties

    private let storage = OAuth2TokenStorage()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "auth_screen_logo") 
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = storage.token {
            fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }

    // MARK: - Setup UI
    
    private func setupSubviews() {
        view.addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Navigation

    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let navigationController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? UINavigationController,
              let viewController = navigationController.viewControllers.first as? AuthViewController else {
            assertionFailure("Failed to instantiate AuthViewController")
            return
        }

        viewController.delegate = self
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    // MARK: - Private Methods

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
            assertionFailure("Invalid window configuration")
            return
        }

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.navigationController?.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            guard let token = self.storage.token else { return }
            self.fetchProfile(token: token)
        }
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
         
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
             
            switch result {
            case .success(let profile):
                 
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in
                     
                }
                 
                self.switchToTabBarController()
                 
            case .failure(let error):
                print("[SplashViewController]: Failed to fetch profile - \(error.localizedDescription)")
            }
        }
    }
}
