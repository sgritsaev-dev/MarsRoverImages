//
//  CamerasViewController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

import UIKit
import SkeletonView

final class CamerasViewController: UIViewController {
    // MARK: - Public properties
    public let viewModel: CamerasViewModel
    
    // MARK: - Private properties
    private var headerView: HeaderView?
    private let tableView = UITableView()
    
    // MARK: - Initializers
    init(viewModel: CamerasViewModel = CamerasViewModel()) {
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
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let headerView = headerView else { return }
        headerView.updateHeader()
        viewModel.delegate = self
        viewModel.delegate?.didChangeSol()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.isSkeletonable = true
        tableView.showSkeleton()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = RoverColors.roverWhite
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
    
    private func setupTableView() {
        tableView.backgroundColor = RoverColors.roverWhite
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CamerasTableViewCell.self, forCellReuseIdentifier: CamerasTableViewCell.identifier)
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        guard let headerView = headerView else { return }
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CamerasViewController: UITableViewDataSource, UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let groupedPhotos = viewModel.groupedPhotos else { return 4 }
        return groupedPhotos.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CamerasTableViewCell.identifier, for: indexPath) as? CamerasTableViewCell else { return UITableViewCell() }
        guard let groupedPhotos = viewModel.groupedPhotos else { return cell }
        cell.configure(groupedPhotos: groupedPhotos[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(156)
    }
}

// MARK: - CamerasViewModelDelegate, CamerasTableViewCellDelegate
extension CamerasViewController: CamerasViewModelDelegate, CamerasTableViewCellDelegate {
    internal func pushToDetails(with camera: String) {
        let detailsViewController = DetailsViewController(viewModel: viewModel)
        detailsViewController.viewModel.selectedCamera = Camera(name: camera)
        detailsViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    internal func didChangeRover() {}
    
    internal func didChangeSol() {
        viewModel.fetchPhotos(rover: viewModel.selectedRover, sol: viewModel.selectedSol) { _ in }
        self.tableView.setContentOffset(CGPoint(x: 0, y: -16), animated: true)
    }
    
    internal func didFetchPhotos() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.hideSkeleton()
        }
    }
}
