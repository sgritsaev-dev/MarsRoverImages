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
    
    var roverImage: GroupedPhotos.Photo? {
        didSet {
            guard let image = roverImage, let url = URL(string: image.imgSrc) else { return }
            Nuke.loadImage(with: url, into: roverImageView)
        }
    }
    
    let roverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = RoverColors.roverDark
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
     let detailsIdLabel = UILabel()
     let detailsDateLabel = UILabel()
    
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
    
    private func setupImage() {
        addSubview(roverImageView)
        
        roverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        roverImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        roverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        roverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        roverImageView.bottomAnchor.constraint(equalTo: detailsIdLabel.topAnchor, constant: -12).isActive = true
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
        
        detailsDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        detailsDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        detailsIdLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        detailsIdLabel.bottomAnchor.constraint(equalTo: detailsDateLabel.topAnchor).isActive = true
    }
}
