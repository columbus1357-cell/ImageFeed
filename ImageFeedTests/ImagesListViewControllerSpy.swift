//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Aleksandr on 09.10.2026.
//

@testable import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var updateTableViewAnimatedCalled = false
    var showLikeErrorAlertCalled = false
    var setCellLikeStatusCalled = false

    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
    }

    func showLikeErrorAlert() {
        showLikeErrorAlertCalled = true
    }

    func setCellLikeStatus(at indexPath: IndexPath, isLiked: Bool) {
        setCellLikeStatusCalled = true
    }
}
