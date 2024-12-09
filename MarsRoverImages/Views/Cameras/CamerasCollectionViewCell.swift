//
//  CamerasCollectionVIewCell.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 22.11.2024.
//

import UIKit
import Nuke

final class CamerasCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CamerasCollectionViewCell"
    
    private var roverImage: Photo? {
        didSet {
            guard let image = roverImage, let url = URL(string: image.imgSrc) else { return }
            Nuke.loadImage(with: url, into: roverImageView)
        }
    }
    private let cameraIdLabel = UILabel()
    private let cameraDateLabel = UILabel()
    private let roverImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
        cameraDateLabel.text = imageDateText
        cameraIdLabel.text = imageIdText
    }
    
    private func setupUI() {
        contentView.backgroundColor = RoverColors.roverWhite
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
        
        NSLayoutConstraint.activate([
            cameraDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cameraDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            cameraIdLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cameraIdLabel.bottomAnchor.constraint(equalTo: cameraDateLabel.topAnchor)
        ])
    }
    
    private func setupImage() {
        roverImageView.layer.cornerRadius = 4
        roverImageView.layer.masksToBounds = true
        roverImageView.backgroundColor = RoverColors.roverDark
        roverImageView.contentMode = .scaleAspectFill
        
        addSubview(roverImageView)
        
        roverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 26 / 100),
            roverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            roverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            roverImageView.bottomAnchor.constraint(equalTo: cameraIdLabel.topAnchor, constant: -12)
        ])
    }
}
