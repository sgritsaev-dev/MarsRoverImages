//
//  CamerasViewController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 18.11.2024.
//

import UIKit

final class CamerasViewController: UIViewController {
    
    private let camerasTableView = UITableView()
    private let tableHead = UIView()
    private let headLargeTitle = UILabel()
    private let headSmallTitle = UILabel()
    private let leftArrow = UIButton()
    private let rightArrow = UIButton()
    
    private var units: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = RoverColors.roverWhite
        setupCamerasTableHead()
        setupTableView()
    }
    
    private func setupCamerasTableHead() {
        tableHead.backgroundColor = RoverColors.roverWhite
        
        headLargeTitle.text = "Spirit"
        headLargeTitle.font = RoverFonts.headLargeFont
        headLargeTitle.textColor = RoverColors.roverDark
        
        headSmallTitle.text = "21.11.2015"
        headSmallTitle.font = RoverFonts.headSmallFont
        headSmallTitle.textColor = RoverColors.roverLight
        
        leftArrow.setImage(UIImage(named: "arrow-left"), for: .normal)
        
        rightArrow.setImage(UIImage(named: "arrow-right"), for: .normal)
        
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
        
        for _ in 1...10 {
            units.append("Unit \(Int.random(in: 1...100))")
        }
    }
}

extension CamerasViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return units.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height/100*6
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CamerasSectionHeaderView()
        headerView.navigationController = self.navigationController
        headerView.backgroundColor = RoverColors.roverWhite
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CamerasTableViewCell().identifier, for: indexPath) as? CamerasTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(view.frame.height*14/100)
    }
}


