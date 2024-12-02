//
//  SettingsViewController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 18.11.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    let networkDataFetcher = RoverPhotoFetcher()
    
    var selectedRover = Rover.curiosity
    
    private let rovers: [Rover] = Rover.allCases
    private var units: [SettingsItem] = []
    
    private let tableView = UITableView()
    private let tableHead = UIView()
    private let headLargeTitle = UILabel()
    private let headSmallTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = RoverColors.roverWhite
        units = rovers.map { roverName in
            return SettingsItem(roverName: roverName, isSelected: roverName.rawValue == "Curiosity")
        }
        setupSettingsTableHead()
        setupTableView()
    }
    
    private func setupSettingsTableHead() {
        tableHead.backgroundColor = RoverColors.roverWhite
        
        headLargeTitle.text = "Марсоходы"
        headLargeTitle.font = RoverFonts.headLargeFont
        headLargeTitle.textColor = RoverColors.roverDark
        
        headSmallTitle.text = "ВЫБИРАЕМ"
        headSmallTitle.font = RoverFonts.headSmallFont
        headSmallTitle.textColor = RoverColors.roverLight
        
        view.addSubview(tableHead)
        tableHead.addSubview(headLargeTitle)
        tableHead.addSubview(headSmallTitle)
        
        tableHead.translatesAutoresizingMaskIntoConstraints = false
        headLargeTitle.translatesAutoresizingMaskIntoConstraints = false
        headSmallTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableHead.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableHead.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableHead.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableHead.heightAnchor.constraint(equalToConstant: (view.bounds.height) / 100 * 13),
            
            headLargeTitle.leadingAnchor.constraint(equalTo: tableHead.leadingAnchor, constant: 16),
            headLargeTitle.centerYAnchor.constraint(equalTo: tableHead.centerYAnchor),
            
            headSmallTitle.leadingAnchor.constraint(equalTo: headLargeTitle.leadingAnchor),
            headSmallTitle.bottomAnchor.constraint(equalTo: headLargeTitle.topAnchor, constant: -8),
        ])
    }
    
    private func setupTableView() {
        tableView.backgroundColor = RoverColors.roverWhite
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableHead.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rovers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let unit = units[indexPath.row]
        cell.textLabel?.text = unit.roverName.rawValue
        cell.textLabel?.font = RoverFonts.settingsFont
        cell.textLabel?.textColor = unit.isSelected ? RoverColors.roverPurple : RoverColors.roverDark
        let checkmarkImageView = UIImageView(image: UIImage(named: "checkbox"))
        cell.accessoryView = unit.isSelected ? checkmarkImageView : .none
        cell.backgroundColor = RoverColors.roverWhite
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let unit = units[indexPath.row]
        selectedRover = unit.roverName
        RoverDataSource.shared.selectedRover = selectedRover
        if unit.isSelected == false {
            units.forEach { $0.isSelected = false }
            unit.isSelected = true
            tableView.reloadData()
        }
    }
}
