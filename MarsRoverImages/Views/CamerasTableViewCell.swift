//
//  CamerasTableViewCell.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 22.11.2024.
//

import UIKit

final class CamerasTableViewCell: UITableViewCell {
    
    let identifier = "CamerasTableViewCell"
    
    var photos: [GroupedPhotos.Photo]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var navigationController: UINavigationController?
    
    let sectionHeader = UILabel()
    private let sectionButton = UIButton()
    private let button = UIImageView()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
        setupHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeader() {
        sectionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        sectionHeader.font = RoverFonts.camerasSectionFont
        sectionHeader.textColor = RoverColors.roverDark
        button.image = UIImage(named: "see all arrow")
        
        contentView.addSubview(sectionButton)
        sectionButton.addSubview(sectionHeader)
        sectionButton.addSubview(button)
        
        sectionButton.translatesAutoresizingMaskIntoConstraints = false
        sectionHeader.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionButton.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            sectionButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            sectionButton.leadingAnchor.constraint(equalTo: sectionHeader.leadingAnchor),
            sectionButton.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            
            sectionHeader.topAnchor.constraint(equalTo: sectionButton.topAnchor),
            sectionHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            button.topAnchor.constraint(equalTo: sectionButton.topAnchor),
            button.leadingAnchor.constraint(equalTo: sectionHeader.trailingAnchor, constant: 10)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.register(CamerasCollectionViewCell.self, forCellWithReuseIdentifier: "CamerasCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = RoverColors.roverWhite
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc func buttonTapped() {
        if let navigationController = self.navigationController {
            let detailsController = DetailsViewController()
            detailsController.delegate = navigationController.topViewController as? CamerasViewController
            detailsController.detailsPhotos = self.photos
            detailsController.cameraName = self.sectionHeader.text ?? "Camera Name"
            detailsController.modalPresentationStyle = .fullScreen
            navigationController.pushViewController(detailsController, animated: true)
        }
    }
}

extension CamerasTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CamerasCollectionViewCell", for: indexPath) as? CamerasCollectionViewCell else { return UICollectionViewCell() }
        guard let photo = (collectionView.dataSource as? CamerasTableViewCell)?.photos?[indexPath.item] else { return cell }
        cell.collectionView = collectionView
        cell.indexPath = indexPath
        cell.roverImage = photo
        cell.cameraDateLabel.text = urlToRus(urlDate: photo.earthDate)
        cell.cameraIdLabel.text = "id #\(photo.id)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width * 0.33
        return CGSize(width: width, height: height)
    }
}
