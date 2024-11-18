//
//  CamerasCollectionVIewCell.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 22.11.2024.
//

import UIKit

final class CamerasCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CamerasCollectionViewCell"
    internal let roverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let cameraIdLabel = UILabel()
    private let cameraSolLabel = UILabel()
    
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
        
        roverImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        roverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        roverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        roverImageView.bottomAnchor.constraint(equalTo: cameraIdLabel.topAnchor, constant: -12).isActive = true
    }
    
    private func setupLabels() {
        cameraIdLabel.text = "USSR"
        cameraIdLabel.font = RoverFonts.detailsLargeFont
        cameraIdLabel.textColor = RoverColors.roverDark
        
        cameraSolLabel.text = "USSR"
        cameraSolLabel.font = RoverFonts.detailsSmallFont
        cameraSolLabel.textColor = RoverColors.roverLight
        
        addSubview(cameraIdLabel)
        addSubview(cameraSolLabel)
        
        cameraIdLabel.translatesAutoresizingMaskIntoConstraints = false
        cameraSolLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cameraSolLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cameraSolLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        cameraIdLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cameraIdLabel.bottomAnchor.constraint(equalTo: cameraSolLabel.topAnchor).isActive = true
    }
}
