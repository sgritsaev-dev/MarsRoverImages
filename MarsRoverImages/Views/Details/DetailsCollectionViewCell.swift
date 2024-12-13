//
//  DetailsCollectionViewCell.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.11.2024.
//

import UIKit
import Nuke

final class DetailsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DetailsCollectionViewCell"
    
    private var roverImage: Photo? {
        didSet {
            guard let image = roverImage, let url = URL(string: image.imgSrc) else { return }
            Nuke.loadImage(with: url, into: roverImageView)
        }
    }
    private let detailsIdLabel = UILabel()
    private let detailsDateLabel = UILabel()
    private let roverImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabels()
        setupImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        roverImageView.image = nil
    }
    
    func configure(image: Photo?, imageDateText: String, imageIdText: String) {
        roverImage = image
        detailsDateLabel.text = imageDateText
        detailsIdLabel.text = imageIdText
    }
    
    private func setupLabels() {
        detailsIdLabel.font = RoverFonts.detailsLargeFont
        detailsIdLabel.textColor = RoverColors.roverDark
        
        detailsDateLabel.font = RoverFonts.detailsSmallFont
        detailsDateLabel.textColor = RoverColors.roverLight
        
        addSubview(detailsIdLabel)
        addSubview(detailsDateLabel)
        
        detailsIdLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailsDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            detailsDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            detailsIdLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            detailsIdLabel.bottomAnchor.constraint(equalTo: detailsDateLabel.topAnchor)
        ])
    }
    
    private func setupImage() {
        roverImageView.backgroundColor = RoverColors.roverDark
        roverImageView.layer.cornerRadius = 4
        roverImageView.layer.masksToBounds = true
        roverImageView.contentMode = .scaleToFill
        
        addSubview(roverImageView)
        
        roverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roverImageView.topAnchor.constraint(equalTo: self.topAnchor),
            roverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            roverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            roverImageView.bottomAnchor.constraint(equalTo: detailsIdLabel.topAnchor, constant: -12)
        ])
    }
}
