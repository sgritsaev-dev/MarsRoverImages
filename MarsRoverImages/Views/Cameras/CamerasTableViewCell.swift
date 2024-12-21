//
//  CamerasTableViewCell.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

import UIKit

final class CamerasTableViewCell: UITableViewCell {
    // MARK: - Public properties
    public weak var delegate: CamerasTableViewCellDelegate?
    public static let identifier = "CamerasTableViewCell"
    
    // MARK: - Private properties
    private var photos: [Photo]? {
        didSet {
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            collectionView.reloadData()
        }
    }
    private let cameraHeader = UILabel()
    private let cameraButton = UIButton()
    private let buttonImage = UIImageView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionViewLayout()
        setupHeader()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    public func configure(groupedPhotos: GroupedPhotos) {
        cameraHeader.text = groupedPhotos.camera?.name
        photos = groupedPhotos.photos
    }
    
    // MARK: - Private methods
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
            cameraButton.heightAnchor.constraint(equalToConstant: 20),
            cameraButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            cameraButton.leadingAnchor.constraint(equalTo: cameraHeader.leadingAnchor),
            cameraButton.trailingAnchor.constraint(equalTo: buttonImage.trailingAnchor),
            
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
            collectionView.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -12)
        ])
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    @objc
    private func cameraButtonTapped() {
        guard let camera = self.cameraHeader.text else { return }
        delegate?.pushToDetails(with: camera)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CamerasTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = photos?.count else { return 4 }
        return number
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CamerasCollectionViewCell", for: indexPath) as? CamerasCollectionViewCell else { return UICollectionViewCell() }
        guard let cameraPhotos = photos else { return cell }
        cell.configure(photo: cameraPhotos[indexPath.item])
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height * 138 / 121
        return CGSize(width: width, height: height)
    }
}

// MARK: - Protocols
protocol CamerasTableViewCellDelegate: AnyObject {
    func pushToDetails(with camera: String)
}
