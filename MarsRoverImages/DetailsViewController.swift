//
//  DetailsViewController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.11.2024.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    private let collectionHead = UIView()
    private let headLargeTitle = UILabel()
    private let headSmallTitle = UILabel()
    private let leftArrow = UIButton()
    private let rightArrow = UIButton()
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private let images = Array(repeating: UIImage(named: "ussr")!, count: 20)
    private let detailsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailsTableHead()
        setupCollectionView()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setupDetailsTableHead() {
        collectionHead.backgroundColor = RoverColors.roverWhite
        
        headLargeTitle.text = "Spirit"
        headLargeTitle.font = RoverFonts.headLargeFont
        headLargeTitle.textColor = RoverColors.roverDark
        
        headSmallTitle.text = "21.11.2015"
        headSmallTitle.font = RoverFonts.headSmallFont
        headSmallTitle.textColor = RoverColors.roverLight
        
        leftArrow.setImage(UIImage(named: "arrow-left"), for: .normal)
        
        rightArrow.setImage(UIImage(named: "arrow-right"), for: .normal)
        
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
        layout.itemSize = calculateSize()
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
    
    private func calculateSize() -> CGSize {
        let paddingSpace = sectionInsets.left * 2 + 4
        let availiableWidth = view.frame.width - paddingSpace
        let widthPerItem = availiableWidth / itemsPerRow
        let height = CGFloat(view.frame.height * 16 / 100)
        return CGSize(width: widthPerItem, height: height)
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as! DetailsCollectionViewCell
        cell.roverImageView.image = images[indexPath.item]
        return cell
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
