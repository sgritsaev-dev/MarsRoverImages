//
//  CamerasCollectionViewCell.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

import UIKit
import Nuke
import Lottie

final class CamerasCollectionViewCell: UICollectionViewCell {
    // MARK: - Public properties
    public weak var dispatchDelegate: DispatchWorkItemDelegate?
    public static let identifier = "CamerasCollectionViewCell"
    
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
    private let cameraIdLabel = UILabel()
    private let cameraDateLabel = UILabel()
    private let roverImageView = UIImageView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
        cameraDateLabel.text = photo.earthDate.dateToRus
        cameraIdLabel.text = "id #\(photo.id)"
    }
    
    // MARK: - Private methods
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
        roverImageView.contentMode = .scaleAspectFill
        roverImageView.backgroundColor = RoverColors.roverLight.withAlphaComponent(0.1)
        
        addSubview(roverImageView)
        
        roverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roverImageView.topAnchor.constraint(equalTo: self.topAnchor),
            roverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            roverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            roverImageView.bottomAnchor.constraint(equalTo: cameraIdLabel.topAnchor, constant: -12)
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
