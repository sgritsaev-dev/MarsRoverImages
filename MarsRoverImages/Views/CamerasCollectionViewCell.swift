//
//  CamerasCollectionVIewCell.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 22.11.2024.
//

import UIKit
import Nuke

final class CamerasCollectionViewCell: UICollectionViewCell {
    
    let identifier = "CamerasCollectionViewCell"
    
    weak var collectionView: UICollectionView?
    var indexPath: IndexPath?
    
    let roverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = RoverColors.roverDark
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let cameraIdLabel = UILabel()
    let cameraDateLabel = UILabel()
    
    var roverImage: GroupedPhotos.Photo? {
        didSet {
            guard let image = roverImage, let url = URL(string: image.imgSrc) else { return }
            Nuke.loadImage(with: url, into: roverImageView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        roverImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = RoverColors.roverWhite
        setupLabels()
        setupImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImage() {
        addSubview(roverImageView)
        
        roverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        roverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 26 / 100).isActive = true
        roverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        roverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        roverImageView.bottomAnchor.constraint(equalTo: cameraIdLabel.topAnchor, constant: -12).isActive = true
        
    }
    
    private func setupLabels() {
        cameraIdLabel.font = RoverFonts.detailsLargeFont
        cameraIdLabel.textColor = RoverColors.roverDark
        
        cameraDateLabel.font = RoverFonts.detailsSmallFont
        cameraDateLabel.textColor = RoverColors.roverLight
        
        addSubview(cameraIdLabel)
        addSubview(cameraDateLabel)
        
        cameraIdLabel.translatesAutoresizingMaskIntoConstraints = false
        cameraDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cameraDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cameraDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        cameraIdLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cameraIdLabel.bottomAnchor.constraint(equalTo: cameraDateLabel.topAnchor).isActive = true
    }
}
