//
//  CamerasViewController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 18.11.2024.
//

import UIKit

final class CamerasViewController: UIViewController {
    
    let viewModel: CamerasViewModel
    
    private let tableView = UITableView()
    private let tableHead = UIView()
    private let headLargeTitle = UILabel()
    private let headSmallTitle = UILabel()
    private let leftArrow = UIButton()
    private let rightArrow = UIButton()
    
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
        setupCamerasTableHead()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitleText()
        viewModel.delegate = self
        viewModel.delegate?.didChangeSol()
    }
    
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = RoverColors.roverWhite
    }
    
    private func setupCamerasTableHead() {
        tableHead.backgroundColor = RoverColors.roverWhite
        
        headLargeTitle.font = RoverFonts.headLargeFont
        headLargeTitle.textColor = RoverColors.roverDark
        
        headSmallTitle.font = RoverFonts.headSmallFont
        headSmallTitle.textColor = RoverColors.roverLight
        
        leftArrow.setImage(UIImage(named: "arrow-left"), for: .normal)
        leftArrow.addTarget(self, action: #selector(self.minusDay), for: .touchUpInside)
        
        rightArrow.setImage(UIImage(named: "arrow-right"), for: .normal)
        rightArrow.addTarget(self, action: #selector(self.plusDay), for: .touchUpInside)
        
        view.addSubview(tableHead)
        tableHead.addSubview(headLargeTitle)
        tableHead.addSubview(headSmallTitle)
        tableHead.addSubview(leftArrow)
        tableHead.addSubview(rightArrow)
        
        tableHead.translatesAutoresizingMaskIntoConstraints = false
        headLargeTitle.translatesAutoresizingMaskIntoConstraints = false
        headSmallTitle.translatesAutoresizingMaskIntoConstraints = false
        leftArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableHead.heightAnchor.constraint(equalToConstant: (view.bounds.height)/100*13),
            tableHead.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableHead.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableHead.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headLargeTitle.leadingAnchor.constraint(equalTo: tableHead.leadingAnchor, constant: 16),
            headLargeTitle.centerYAnchor.constraint(equalTo: tableHead.centerYAnchor),
            
            headSmallTitle.leadingAnchor.constraint(equalTo: headLargeTitle.leadingAnchor),
            headSmallTitle.bottomAnchor.constraint(equalTo: headLargeTitle.topAnchor, constant: -8),
            
            leftArrow.topAnchor.constraint(equalTo: rightArrow.topAnchor),
            leftArrow.trailingAnchor.constraint(equalTo: rightArrow.leadingAnchor, constant: 12),
            
            rightArrow.trailingAnchor.constraint(equalTo: tableHead.trailingAnchor, constant: -16),
            rightArrow.centerYAnchor.constraint(equalTo: headLargeTitle.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.backgroundColor = RoverColors.roverWhite
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CamerasTableViewCell.self, forCellReuseIdentifier: CamerasTableViewCell().identifier)
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableHead.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

extension CamerasViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let groupedPhotos = viewModel.groupedPhotos else { return 0 }
        return groupedPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CamerasTableViewCell().identifier, for: indexPath) as? CamerasTableViewCell else { return UITableViewCell() }
        guard let groupedPhotos = viewModel.groupedPhotos else { return cell }
        cell.cameraHeader.text = groupedPhotos[indexPath.row].camera?.name
        cell.photos = groupedPhotos[indexPath.row].photos
        cell.navigationController = self.navigationController
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(view.frame.height*20/100)
    }
}

extension CamerasViewController: CamerasViewModelDelegate {
    func didChangeRover() {
    }
    
    func didChangeSol() {
        viewModel.fetchPhotos(rover: viewModel.selectedRover, sol: viewModel.selectedSol) { result in
        }
    }
    
    func didFetchPhotos() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
