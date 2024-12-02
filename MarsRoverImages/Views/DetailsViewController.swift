//
//  DetailsViewController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.11.2024.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    weak var delegate: DetailsViewControllerDelegate?

    let networkDataFetcher = RoverPhotoFetcher()
    
    var cameraName: String = "Camera Name"
    
    var detailsPhotos: [GroupedPhotos.Photo]? {
        didSet {
            detailsCollectionView.reloadData()
        }
    }
    
    private func loadDetailsPhotos(rover: String, sol: Int) {
        self.networkDataFetcher.fetchGroupedPhotos(rover: rover, sol: sol) { [weak self] results in
            self?.detailsPhotos = results.filter { $0.name == self?.cameraName }.first?.photos
            self?.detailsCollectionView.reloadData()
        }
    }
    
    private let collectionHead = UIView()
    private let headLargeTitle = UILabel()
    private let headSmallTitle = UILabel()
    private let leftArrow = UIButton()
    private let rightArrow = UIButton()
    
    private let detailsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RoverDataSource.shared.reloadDelegate = { [weak self] rover, sol in
            self?.loadDetailsPhotos(rover: rover, sol: sol)
            self?.detailsCollectionView.reloadData()
        }
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = RoverColors.roverWhite
        loadDetailsPhotos(rover: RoverDataSource.shared.selectedRover.lowercase, sol: RoverDataSource.shared.selectedSol)
        
        setupDetailsTableHead()
        setupCollectionView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headLargeTitle.text = RoverDataSource.shared.selectedRover.rawValue
        headSmallTitle.text = "СОЛ #\(RoverDataSource.shared.selectedSol)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        delegate?.didUpdateRoverOrSol(rover: RoverDataSource.shared.selectedRover.rawValue, sol: RoverDataSource.shared.selectedSol)
        }
    
    private func setupDetailsTableHead() {
        collectionHead.backgroundColor = RoverColors.roverWhite
        
        headLargeTitle.font = RoverFonts.headLargeFont
        headLargeTitle.textColor = RoverColors.roverDark
        
        headSmallTitle.font = RoverFonts.headSmallFont
        headSmallTitle.textColor = RoverColors.roverLight
        
        leftArrow.setImage(UIImage(named: "arrow-left"), for: .normal)
        leftArrow.addTarget(self, action: #selector(self.minusDay), for: .touchUpInside)
        
        rightArrow.setImage(UIImage(named: "arrow-right"), for: .normal)
        rightArrow.addTarget(self, action: #selector(self.plusDay), for: .touchUpInside)
        
        view.addSubview(collectionHead)
        collectionHead.addSubview(headLargeTitle)
        collectionHead.addSubview(headSmallTitle)
        collectionHead.addSubview(leftArrow)
        collectionHead.addSubview(rightArrow)
        
        collectionHead.translatesAutoresizingMaskIntoConstraints = false
        headLargeTitle.translatesAutoresizingMaskIntoConstraints = false
        headSmallTitle.translatesAutoresizingMaskIntoConstraints = false
        leftArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionHead.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionHead.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionHead.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionHead.heightAnchor.constraint(equalToConstant: (view.bounds.height)/100*13),
            
            headLargeTitle.leadingAnchor.constraint(equalTo: collectionHead.leadingAnchor, constant: 16),
            headLargeTitle.centerYAnchor.constraint(equalTo: collectionHead.centerYAnchor),
            
            headSmallTitle.leadingAnchor.constraint(equalTo: headLargeTitle.leadingAnchor),
            headSmallTitle.bottomAnchor.constraint(equalTo: headLargeTitle.topAnchor, constant: -8),
            
            leftArrow.topAnchor.constraint(equalTo: rightArrow.topAnchor),
            leftArrow.trailingAnchor.constraint(equalTo: rightArrow.leadingAnchor, constant: 12),
            
            rightArrow.trailingAnchor.constraint(equalTo: collectionHead.trailingAnchor, constant: -16),
            rightArrow.centerYAnchor.constraint(equalTo: headLargeTitle.centerYAnchor),
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = calculateItemSize()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16)
        detailsCollectionView.collectionViewLayout = layout
        detailsCollectionView.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: DetailsCollectionViewCell.identifier)
        detailsCollectionView.dataSource = self
        detailsCollectionView.delegate = self
        detailsCollectionView.backgroundColor = RoverColors.roverWhite
        detailsCollectionView.contentInsetAdjustmentBehavior = .automatic
        detailsCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(detailsCollectionView)
        
        detailsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailsCollectionView.topAnchor.constraint(equalTo: collectionHead.bottomAnchor),
            detailsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func calculateItemSize() -> CGSize {
        let width = (view.frame.width - 44) / 2
        let height = CGFloat(view.frame.height * 16 / 100)
        return CGSize(width: width, height: height)
    }
    
    @objc func plusDay() {
        RoverDataSource.shared.selectedSol += 1
        headSmallTitle.text = "СОЛ #\(RoverDataSource.shared.selectedSol)"
    }

    @objc func minusDay() {
        RoverDataSource.shared.selectedSol -= 1
        headSmallTitle.text = "СОЛ #\(RoverDataSource.shared.selectedSol)"
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = detailsPhotos?.count else { return 0 }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as! DetailsCollectionViewCell
        guard let photo = detailsPhotos?[indexPath.item] else { return cell }
        cell.detailsDateLabel.text = urlToRus(urlDate: photo.earthDate)
        cell.detailsIdLabel.text = "id #\(photo.id)"
        cell.roverImage = photo
        return cell
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
