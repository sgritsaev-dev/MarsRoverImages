//
//  CamerasViewController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 18.11.2024.
//

import UIKit

final class CamerasViewController: UIViewController, DetailsViewControllerDelegate {
    
    let networkDataFetcher = RoverPhotoFetcher()
    
    private let camerasTableView = UITableView()
    private let tableHead = UIView()
    private let headLargeTitle = UILabel()
    private let headSmallTitle = UILabel()
    private let leftArrow = UIButton()
    private let rightArrow = UIButton()
    
    var camerasPhotoGroups: [GroupedPhotos]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = RoverColors.roverWhite
        RoverDataSource.shared.reloadDelegate = { [weak self] rover, sol in
            self?.loadData(rover: rover, sol: sol)
            self?.camerasTableView.reloadData()
        }
        loadData(rover: RoverDataSource.shared.selectedRover.lowercase, sol: RoverDataSource.shared.selectedSol)
        setupCamerasTableHead()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headLargeTitle.text = RoverDataSource.shared.selectedRover.rawValue
        headSmallTitle.text = "СОЛ #\(RoverDataSource.shared.selectedSol)"
    }
    
    func didUpdateRoverOrSol(rover: String, sol: Int) {
        loadData(rover: rover, sol: sol)
        camerasTableView.reloadData()
    }
    
    private func loadData(rover: String, sol: Int) {
        self.networkDataFetcher.fetchGroupedPhotos(rover: rover, sol: sol) { [weak self] results in
            self?.camerasPhotoGroups = results
            self?.camerasTableView.reloadData()
        }
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
            rightArrow.centerYAnchor.constraint(equalTo: headLargeTitle.centerYAnchor),
        ])
    }
    
    private func setupTableView() {
        camerasTableView.backgroundColor = RoverColors.roverWhite
        camerasTableView.showsVerticalScrollIndicator = false
        camerasTableView.sectionHeaderTopPadding = 0
        camerasTableView.separatorStyle = .none
        
        camerasTableView.dataSource = self
        camerasTableView.delegate = self
        camerasTableView.register(CamerasTableViewCell.self, forCellReuseIdentifier: CamerasTableViewCell().identifier)
        
        view.addSubview(camerasTableView)
        
        camerasTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            camerasTableView.topAnchor.constraint(equalTo: tableHead.bottomAnchor),
            camerasTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            camerasTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            camerasTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

extension CamerasViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = camerasPhotoGroups?.count else {return 0}
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CamerasTableViewCell().identifier, for: indexPath) as? CamerasTableViewCell else { return UITableViewCell() }
        guard let group = camerasPhotoGroups?[indexPath.row] else { return cell }
        cell.photos = group.photos
        cell.sectionHeader.text = group.name
        cell.navigationController = navigationController
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(view.frame.height*20/100)
    }
}
