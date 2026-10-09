//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Aleksandr on 09.10.2026.
//

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var updateProfileDetailsCalled = false
    var updateAvatarCalled = false

    func updateProfileDetails(profile: Profile?) {
        updateProfileDetailsCalled = true
    }

    func updateAvatar(url: URL) {
        updateAvatarCalled = true
    }
}
