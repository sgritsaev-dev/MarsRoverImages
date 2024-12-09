//
//  TableHead.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 09.12.2024.
//

import UIKit

final class HeaderView: UIView {
    
    weak var viewModel: CamerasViewModel?
    
    private let headLargeTitle = UILabel()
    private let headSmallTitle = UILabel()
    private let leftArrow = UIButton()
    private let rightArrow = UIButton()
    
    init(frame: CGRect, viewModel: CamerasViewModel) {
        super.init(frame: frame)
        self.viewModel = viewModel
        setupUI()
        configureTableHead(with: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = RoverColors.roverWhite
        
        headLargeTitle.font = RoverFonts.headLargeFont
        headLargeTitle.textColor = RoverColors.roverDark
        
        headSmallTitle.font = RoverFonts.headSmallFont
        headSmallTitle.textColor = RoverColors.roverLight
        
        leftArrow.setImage(UIImage(named: "arrow-left"), for: .normal)
        
        rightArrow.setImage(UIImage(named: "arrow-right"), for: .normal)
        
        addSubview(headLargeTitle)
        addSubview(headSmallTitle)
        addSubview(leftArrow)
        addSubview(rightArrow)
        
        headLargeTitle.translatesAutoresizingMaskIntoConstraints = false
        headSmallTitle.translatesAutoresizingMaskIntoConstraints = false
        leftArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headLargeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headLargeTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            headSmallTitle.leadingAnchor.constraint(equalTo: headLargeTitle.leadingAnchor),
            headSmallTitle.bottomAnchor.constraint(equalTo: headLargeTitle.topAnchor, constant: -8),
            
            leftArrow.topAnchor.constraint(equalTo: rightArrow.topAnchor),
            leftArrow.trailingAnchor.constraint(equalTo: rightArrow.leadingAnchor, constant: 12),
            
            rightArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightArrow.centerYAnchor.constraint(equalTo: headLargeTitle.centerYAnchor)
        ])
    }
    
    func configureTableHead(with viewModel: CamerasViewModel) {
        leftArrow.addTarget(self, action: #selector(self.minusDay), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(self.plusDay), for: .touchUpInside)
        updateHeader()
    }
    
    func updateHeader() {
        guard let viewModel = viewModel else { return }
        headLargeTitle.text = viewModel.selectedRover.roverName.rawValue
        headSmallTitle.text = "СОЛ #\(viewModel.selectedSol)"
    }
    
    @objc func plusDay() {
        guard let viewModel = viewModel else { return }
        viewModel.selectedSol += 1
        updateHeader()
    }
    
    @objc func minusDay() {
        guard let viewModel = viewModel else { return }
        viewModel.selectedSol -= 1
        updateHeader()
    }
}
