//
//  CamerasSectionHeaderView.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 22.11.2024.
//

import UIKit

final class CamerasSectionHeaderView: UIView {
    
    weak var navigationController: UINavigationController?
    
    private let sectionName = "FHAZ"
    private let sectionHeader = UILabel()
    private let sectionButton = UIButton()
    private let button = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeader() {
        sectionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        sectionHeader.text = sectionName
        sectionHeader.font = RoverFonts.camerasSectionFont
        sectionHeader.textColor = RoverColors.roverDark
        
        button.image = UIImage(named: "see all arrow")
        
        addSubview(sectionButton)
        sectionButton.addSubview(sectionHeader)
        sectionButton.addSubview(button)
        
        sectionButton.translatesAutoresizingMaskIntoConstraints = false
        sectionHeader.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionButton.heightAnchor.constraint(equalToConstant: 52),
            sectionButton.widthAnchor.constraint(equalToConstant: 104),
            sectionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sectionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            sectionHeader.leadingAnchor.constraint(equalTo: sectionButton.leadingAnchor),
            sectionHeader.centerYAnchor.constraint(equalTo: sectionButton.centerYAnchor),
            
            button.leadingAnchor.constraint(equalTo: sectionHeader.trailingAnchor, constant: 10),
            button.centerYAnchor.constraint(equalTo: sectionButton.centerYAnchor)
        ])
    }
    
    @objc func buttonTapped() {
        if let navigationController = navigationController {
            let detailsController = DetailsViewController()
            detailsController.modalPresentationStyle = .fullScreen
            navigationController.pushViewController(detailsController, animated: true)
        }
    }
}
