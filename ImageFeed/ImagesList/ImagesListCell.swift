//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Aleksandr on 31.07.2026.
//


import UIKit
import Kingfisher

// MARK: - ImagesListCellDelegate

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

// MARK: - ImagesListCell

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Public Properties
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    // MARK: - Private Properties
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradient()
        likeButton.accessibilityIdentifier = "like button"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(
            x: 0,
            y: cellImage.bounds.height - 35,
            width: cellImage.bounds.width,
            height: 35
        )
    }
    
    // MARK: - IBActions
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Public Methods
    
    func configCell(with photo: Photo, dateFormatter: DateFormatter) {
        cellImage.kf.indicatorType = .activity
        
        if let thumbURL = URL(string: photo.thumbImageURL) {
            cellImage.kf.setImage(
                with: thumbURL,
                placeholder: UIImage(named: "stub")
            )
        } else {
            cellImage.image = UIImage(named: "stub")
        }
        
        if let date = photo.createdAt {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
        
        setIsLiked(photo.isLiked)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = UIImage(resource: isLiked ? .likeActive : .likeNoActive)
        likeButton.setImage(likeImage, for: .normal)
    }
    
    // MARK: - Private Methods
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.6).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        cellImage.layer.addSublayer(gradientLayer)
    }
}
