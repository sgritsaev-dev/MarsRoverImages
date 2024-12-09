//
//  CamerasViewController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 18.11.2024.
//

import UIKit

final class CamerasViewController: UIViewController {
    
    let viewModel: CamerasViewModel
    
    private var headerView: HeaderView?
    private let tableView = UITableView()
    
    init() {
        self.viewModel = CamerasViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            headerView.heightAnchor.constraint(equalToConstant: (view.bounds.height)/100*13),
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

extension CamerasViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let groupedPhotos = viewModel.groupedPhotos else { return 0 }
        return groupedPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CamerasTableViewCell.identifier, for: indexPath) as? CamerasTableViewCell else { return UITableViewCell() }
        guard let groupedPhotos = viewModel.groupedPhotos else { return cell }
        cell.configure(cameraHeaderText: groupedPhotos[indexPath.row].camera?.name, cameraPhotos: groupedPhotos[indexPath.row].photos, cellDelegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(158)
    }
}

extension CamerasViewController: CamerasViewModelDelegate, CamerasTableViewCellDelegate {
    func pushToDetails(with camera: String) {
        let detailsViewController = DetailsViewController(viewModel: viewModel)
        detailsViewController.viewModel.selectedCamera = Camera(name: camera)
        detailsViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func didChangeRover() {}
    
    func didChangeSol() {
        viewModel.fetchPhotos(rover: viewModel.selectedRover, sol: viewModel.selectedSol) { _ in }
    }
    
    func didFetchPhotos() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
