//
//  DetailsCollectionViewCell.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.11.2024.
//

import UIKit

final class DetailsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DetailsCollectionViewCell"
    
    let roverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let detailsIdLabel = UILabel()
    private let detailsSolLabel = UILabel()
    
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
        detailsIdLabel.text = "USSR"
        detailsIdLabel.font = RoverFonts.detailsLargeFont
        detailsIdLabel.textColor = RoverColors.roverDark
        
        detailsSolLabel.text = "USSR"
        detailsSolLabel.font = RoverFonts.detailsSmallFont
        detailsSolLabel.textColor = RoverColors.roverLight
        
        addSubview(detailsIdLabel)
        addSubview(detailsSolLabel)
        
        detailsIdLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsSolLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailsSolLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        detailsSolLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        detailsIdLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        detailsIdLabel.bottomAnchor.constraint(equalTo: detailsSolLabel.topAnchor).isActive = true
    }
}
