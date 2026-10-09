//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Aleksandr on 09.10.2026.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)

        // when
        _ = viewController.view

        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterCallsFetchPhotosNextPage() {
        // given
        let presenter = ImagesListPresenterSpy()

        // when
        presenter.fetchPhotosNextPage()

        // then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
}
