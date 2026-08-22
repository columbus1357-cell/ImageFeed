//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Aleksandr on 08.08.2026.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    //MARK: - Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
            
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
        
    }
    
    //MARK: - Actions
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let shareController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(shareController, animated: true, completion: nil)
    }
    
    //MARK: - Private Methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 3.0
        
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
