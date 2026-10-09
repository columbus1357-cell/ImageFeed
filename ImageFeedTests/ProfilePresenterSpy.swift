//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Aleksandr on 09.10.2026.
//

@testable import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var logOutCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func logOut() {
        logOutCalled = true
    }
}
