//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Aleksandr on 31.07.2026.
//

import UIKit

// MARK: - ImagesListCell

final class ImagesListCell: UITableViewCell {

    // MARK: - Static Properties

    static let reuseIdentifier = "ImagesListCell"

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

    // MARK: - Public Methods

    func configCell(image: UIImage, dateText: String, isLiked: Bool) {
        cellImage.image = image
        dateLabel.text = dateText
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

        cellImage.layer.insertSublayer(gradientLayer, at: 0)
    }
}
