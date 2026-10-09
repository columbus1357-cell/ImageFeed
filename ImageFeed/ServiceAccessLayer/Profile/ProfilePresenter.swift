//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Aleksandr on 09.10.2026.
//

import Foundation

// MARK: - Protocols

protocol ProfileViewControllerProtocol: AnyObject {
    func updateProfileDetails(profile: Profile?)
    func updateAvatar(url: URL)
}

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logOut()
}

// MARK: - ProfilePresenter

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let profileLogoutService: ProfileLogoutService
    
    init(
        profileService: ProfileService = .shared,
        profileImageService: ProfileImageService = .shared,
        profileLogoutService: ProfileLogoutService = .shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func viewDidLoad() {
        // 1. Передаем профиль во View
        view?.updateProfileDetails(profile: profileService.profile)
        
        // 2. Настраиваем наблюдатель за обновлением аватарки
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.updateAvatar()
        }
        
        // 3. Обновляем аватарку сразу при загрузке
        updateAvatar()
    }
    
    func logOut() {
        profileLogoutService.logout()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.updateAvatar(url: url)
    }
}
