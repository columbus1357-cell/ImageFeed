//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Aleksandr on 08.08.2026.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let errorTitle = "Ошибка"
        static let errorMessage = "Что-то пошло не так. Попробовать ещё раз?"
        static let cancelTitle = "Не надо"
        static let retryTitle = "Повторить"
        
        static let minInitialZoomScale: CGFloat = 0.1
        static let maxInitialZoomScale: CGFloat = 1.25
        static let minRescaleZoomScale: CGFloat = 0.5
        static let maxRescaleZoomScale: CGFloat = 3.0
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    
    var imageURL: URL? {
        didSet {
            guard isViewLoaded, let imageURL else { return }
            setImage(with: imageURL)
        }
    }
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = Constants.minInitialZoomScale
        scrollView.maximumZoomScale = Constants.maxInitialZoomScale
        
        if let imageURL {
            setImage(with: imageURL)
        } else if let image {
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let shareController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(shareController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    
    private func setImage(with url: URL) {
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: Constants.errorTitle,
            message: Constants.errorMessage,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: Constants.cancelTitle, style: .default)
        let retryAction = UIAlertAction(title: Constants.retryTitle, style: .default) { [weak self] _ in
            guard let self, let imageURL = self.imageURL else { return }
            self.setImage(with: imageURL)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        
        present(alert, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        scrollView.minimumZoomScale = Constants.minRescaleZoomScale
        scrollView.maximumZoomScale = Constants.maxRescaleZoomScale
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let boundsSize = scrollView.bounds.size
        let imageFrame = imageView.frame
        
        let horizontalInset = imageFrame.width < boundsSize.width
            ? (boundsSize.width - imageFrame.width) / 2
            : 0
            
        let verticalInset = imageFrame.height < boundsSize.height
            ? (boundsSize.height - imageFrame.height) / 2
            : 0
            
        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }
}
