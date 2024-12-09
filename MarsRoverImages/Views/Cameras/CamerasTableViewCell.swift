//
//  CamerasTableViewCell.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 22.11.2024.
//

import UIKit

final class CamerasTableViewCell: UITableViewCell {
    
    static let identifier = "CamerasTableViewCell"
    
    private var photos: [Photo]? {
        didSet {
            collectionView.reloadData()
        }
    }
    weak var delegate: CamerasTableViewCellDelegate?
    
    private let cameraHeader = UILabel()
    private let cameraButton = UIButton()
    private let buttonImage = UIImageView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionViewLayout()
        setupCollectionView()
        setupHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(cameraHeaderText: String?, cameraPhotos: [Photo], cellDelegate: CamerasTableViewCellDelegate) {
        cameraHeader.text = cameraHeaderText
        photos = cameraPhotos
        delegate = cellDelegate
    }
    
    private func setupHeader() {
        cameraHeader.font = RoverFonts.camerasSectionFont
        cameraHeader.textColor = RoverColors.roverDark
        
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        buttonImage.image = UIImage(named: "see all arrow")
        
        contentView.addSubview(cameraButton)
        cameraButton.addSubview(cameraHeader)
        cameraButton.addSubview(buttonImage)
        
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraHeader.translatesAutoresizingMaskIntoConstraints = false
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cameraButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            cameraButton.leadingAnchor.constraint(equalTo: cameraHeader.leadingAnchor),
            cameraButton.trailingAnchor.constraint(equalTo: buttonImage.trailingAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            cameraHeader.topAnchor.constraint(equalTo: cameraButton.topAnchor),
            cameraHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            buttonImage.topAnchor.constraint(equalTo: cameraButton.topAnchor),
            buttonImage.leadingAnchor.constraint(equalTo: cameraHeader.trailingAnchor, constant: 10)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = RoverColors.roverWhite
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.register(CamerasCollectionViewCell.self, forCellWithReuseIdentifier: "CamerasCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    @objc func cameraButtonTapped() {
        guard let camera = self.cameraHeader.text else { return }
        delegate?.pushToDetails(with: camera)
    }
}

extension CamerasTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = photos?.count else { return 0 }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CamerasCollectionViewCell", for: indexPath) as? CamerasCollectionViewCell else { return UICollectionViewCell() }
        guard let cameraPhotos = photos else { return cell }
        let photo = cameraPhotos[indexPath.item]
        cell.configure(image: photo, imageDateText: photo.earthDate.dateToRus, imageIdText: "id #\(photo.id)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * 0.83
        return CGSize(width: width, height: height)
    }
}

protocol CamerasTableViewCellDelegate: AnyObject {
    func pushToDetails(with camera: String)
}
