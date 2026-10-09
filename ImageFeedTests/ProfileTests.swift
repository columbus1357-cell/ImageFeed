//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Aleksandr on 09.10.2026.
//

import Foundation

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)

        // when
        _ = viewController.view

        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterCallsUpdateProfileDetails() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController

        // when
        presenter.viewDidLoad()

        // then
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
}
