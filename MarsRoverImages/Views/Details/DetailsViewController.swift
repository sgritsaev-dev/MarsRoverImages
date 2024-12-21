//
//  DetailsViewController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

import UIKit

final class DetailsViewController: UIViewController {
    // MARK: - Public properties
    public let viewModel: CamerasViewModel
    
    // MARK: - Private properties
    private var headerView: HeaderView?
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Initializers
    init(viewModel: CamerasViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupHeaderView()
        setupCollectionViewLayout()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let headerView = headerView else { return }
        headerView.updateHeader()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        viewModel.delegate = self
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = RoverColors.roverWhite
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setupHeaderView() {
        let headerView = HeaderView(frame: .zero, viewModel: viewModel)
        self.headerView = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: (view.bounds.height) / 896 * 100),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width - 44) / 2
        let height = (width * 149 / 188)
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 8, right: 16)
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
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        guard let headerView = headerView else { return }
        collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = viewModel.selectedCameraPhotos?.photos.count else { return 0 }
        return number
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as? DetailsCollectionViewCell else { return UICollectionViewCell() }
        guard let photos = viewModel.selectedCameraPhotos?.photos else { return cell }
        cell.configure(photo: photos[indexPath.item])
        return cell
    }
}

// MARK: - UIGestureRecognizerDelegate
extension DetailsViewController: UIGestureRecognizerDelegate {
    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - CamerasViewModelDelegate
extension DetailsViewController: CamerasViewModelDelegate {
    internal func didChangeRover() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    internal func didChangeSol() {
        viewModel.fetchPhotos(rover: viewModel.selectedRover, sol: viewModel.selectedSol) { [weak self] result in
            self?.viewModel.selectedCameraPhotos = result?.first(where: { $0.camera == self?.viewModel.selectedCamera })
        }
    }
    
    internal func didFetchPhotos() {
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.collectionView.reloadData()
        }
    }
}
