//
//  SettingsViewController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    // MARK: - Public properies
    public let viewModel: SettingsViewModel
    
    // MARK: - Private properties
    private let tableView = UITableView()
    private let tableHead = UIView()
    private let headLargeTitle = UILabel()
    private let headSmallTitle = UILabel()
    
    // MARK: - Initializers
    init(viewModel: SettingsViewModel = SettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = RoverColors.roverWhite
        setupSettingsTableHead()
        setupTableView()
    }
    
    // MARK: - Private methods
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

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rovers.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let rover = viewModel.rovers[indexPath.row]
        cell.textLabel?.text = rover.roverName.rawValue
        cell.textLabel?.font = RoverFonts.settingsFont
        cell.textLabel?.textColor = rover == viewModel.selectedRover ? RoverColors.roverPurple : RoverColors.roverDark
        let checkmarkImageView = UIImageView(image: UIImage(named: "checkbox"))
        cell.accessoryView = rover == viewModel.selectedRover ? checkmarkImageView : .none
        cell.backgroundColor = RoverColors.roverWhite
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rover = viewModel.rovers[indexPath.row]
        if rover != viewModel.selectedRover {
            viewModel.selectedRover = rover
            tableView.reloadData()
        }
    }
}
