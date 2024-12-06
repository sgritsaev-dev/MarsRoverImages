//
//  DetailsViewController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.11.2024.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    let viewModel: CamerasViewModel
    
    private let collectionHead = UIView()
    private let headLargeTitle = UILabel()
    private let headSmallTitle = UILabel()
    private let leftArrow = UIButton()
    private let rightArrow = UIButton()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init(viewModelManager: ViewModelManager) {
        self.viewModel = viewModelManager.camerasViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDetailsTableHead()
        setupCollectionViewLayout()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitleText()
    }
    
    private func setupUI() {
        viewModel.delegate = self
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = RoverColors.roverWhite
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
            collectionHead.heightAnchor.constraint(equalToConstant: (view.bounds.height)/100*13),
            collectionHead.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionHead.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionHead.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headLargeTitle.leadingAnchor.constraint(equalTo: collectionHead.leadingAnchor, constant: 16),
            headLargeTitle.centerYAnchor.constraint(equalTo: collectionHead.centerYAnchor),
            
            headSmallTitle.leadingAnchor.constraint(equalTo: headLargeTitle.leadingAnchor),
            headSmallTitle.bottomAnchor.constraint(equalTo: headLargeTitle.topAnchor, constant: -8),
            
            leftArrow.topAnchor.constraint(equalTo: rightArrow.topAnchor),
            leftArrow.trailingAnchor.constraint(equalTo: rightArrow.leadingAnchor, constant: 12),
            
            rightArrow.trailingAnchor.constraint(equalTo: collectionHead.trailingAnchor, constant: -16),
            rightArrow.centerYAnchor.constraint(equalTo: headLargeTitle.centerYAnchor)
        ])
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width - 44) / 2
        let height = (view.frame.height * 16 / 100)
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16)
        collectionView.collectionViewLayout = layout
    }
    
    private func setupCollectionView() {
        collectionView.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: DetailsCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = RoverColors.roverWhite
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: collectionHead.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTitleText() {
        headLargeTitle.text = viewModel.selectedRover.roverName.rawValue
        updateSolText()
    }
    
    private func updateSolText() {
        headSmallTitle.text = "СОЛ #\(viewModel.selectedSol)"
    }
    
    @objc func plusDay() {
        viewModel.selectedSol += 1
        updateSolText()
    }
    
    @objc func minusDay() {
        viewModel.selectedSol -= 1
        updateSolText()
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = viewModel.selectedCameraPhotos?.photos.count else { return 0 }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as! DetailsCollectionViewCell
        guard let photos = viewModel.selectedCameraPhotos?.photos else { return cell }
        let photo = photos[indexPath.item]
        cell.detailsDateLabel.text = urlToRus(urlDate: photo.earthDate)
        cell.detailsIdLabel.text = "id #\(photo.id)"
        cell.roverImage = photo
        return cell
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DetailsViewController: CamerasViewModelDelegate {
    func didChangeRover() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func didChangeSol() {
        viewModel.fetchPhotos(rover: viewModel.selectedRover, sol: viewModel.selectedSol) { [weak self] result in
            self?.viewModel.selectedCameraPhotos = result?.first(where: { $0.camera == self?.viewModel.selectedCamera })
        }
    }
    
    func didFetchPhotos() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
