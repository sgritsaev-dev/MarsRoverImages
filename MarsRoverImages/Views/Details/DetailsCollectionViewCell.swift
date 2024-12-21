//
//  DetailsCollectionViewCell.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

import UIKit
import Nuke
import Lottie

final class DetailsCollectionViewCell: UICollectionViewCell {
    // MARK: - Public properties
    public weak var dispatchDelegate: DispatchWorkItemDelegate?
    public static let identifier = "DetailsCollectionViewCell"
    
    // MARK: - Private properties
    private var lottieLoading = LottieAnimationView()
    private var lottieNotFound = LottieAnimationView()
    private var roverImage: Photo? {
        didSet {
            guard let image = self.roverImage, let url = URL(string: image.imgSrc) else { return }
            let workItem = DispatchWorkItem {
                self.setupLottieLoading()
                self.lottieLoading.play()
                Nuke.loadImage(with: url, into: self.roverImageView) { [weak self] response in
                    switch response {
                    case .success:
                        DispatchQueue.main.async {
                            self?.lottieLoading.stop()
                            self?.lottieLoading.removeFromSuperview()
                        }
                    case .failure:
                        break
                    }
                }
            }
            dispatchDelegate?.addDispatchWorkItem(workItem: workItem)
            DispatchQueue.main.async(execute: workItem)
        }
    }
    private let detailsIdLabel = UILabel()
    private let detailsDateLabel = UILabel()
    private let roverImageView = UIImageView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabels()
        setupImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse methods
    override func prepareForReuse() {
        super.prepareForReuse()
        roverImageView.image = nil
    }
    
    // MARK: - Public methods
    public func configure(photo: Photo) {
        roverImage = photo
        detailsDateLabel.text = photo.earthDate.dateToRus
        detailsIdLabel.text = "id #\(photo.id)"
    }
    
    // MARK: - Private methods
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
        roverImageView.backgroundColor = RoverColors.roverLight.withAlphaComponent(0.1)
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
    
    private func setupLottieLoading() {
        lottieLoading.animation = .asset("lottieLoading")
        lottieLoading.loopMode = .loop
        lottieLoading.animationSpeed = 0.5
        lottieLoading.contentMode = .scaleAspectFit
        lottieLoading.frame = roverImageView.bounds
        
        addSubview(lottieLoading)
    }
}
