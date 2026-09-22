//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Aleksandr on 19.08.2026.
//

import UIKit
import os
import ProgressHUD

// MARK: - AuthViewControllerDelegate

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

// MARK: - AuthViewController

final class AuthViewController: UIViewController {

    // MARK: - Private Properties

    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "ImageFeed",
        category: "AuthViewController"
    )
    
    // MARK: - Public Properties

    weak var delegate: AuthViewControllerDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    // MARK: - Private Methods

    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(resource: .navBackButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .navBackButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(resource: .ypBlack)
    }
    
    private func showLoginErrorAlert() {
            let alert = UIAlertController(
                title: "Что-то пошло не так",
                message: "Не удалось войти в систему",
                preferredStyle: .alert
            )
            
            let action = UIAlertAction(title: "Ок", style: .default)
            alert.addAction(action)
            
            present(alert, animated: true)
        }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        UIBlockingProgressHUD.show()
        
        navigationController?.popViewController(animated: true)
        
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token
                self.delegate?.didAuthenticate(self)
                
            case .failure(let error):
                self.logger.error("Failed to fetch OAuth token: \(error.localizedDescription, privacy: .public)")
                self.showLoginErrorAlert()
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        navigationController?.popViewController(animated: true)
    }
}
