//
//  HeaderView.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

import UIKit

final class HeaderView: UIView {
    // MARK: - Public properties
    public weak var viewModel: CamerasViewModel?
    
    // MARK: - Private properties
    private let headLargeTitle = UILabel()
    private let headSmallTitle = UILabel()
    private let leftArrow = UIButton()
    private let rightArrow = UIButton()
    private let bottomBorder = UIView()
    
    // MARK: - Initializers
    init(frame: CGRect, viewModel: CamerasViewModel) {
        super.init(frame: frame)
        self.viewModel = viewModel
        setupUI()
        configureTableHead(with: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    public func updateHeader() {
        guard let viewModel = viewModel else { return }
        headLargeTitle.text = viewModel.selectedRover.roverName.rawValue
        headSmallTitle.text = "СОЛ #\(viewModel.selectedSol)"
    }
    
    // MARK: - Private methods
    private func setupUI() {
        backgroundColor = RoverColors.roverWhite
        
        headLargeTitle.font = RoverFonts.headLargeFont
        headLargeTitle.textColor = RoverColors.roverDark
        
        headSmallTitle.font = RoverFonts.headSmallFont
        headSmallTitle.textColor = RoverColors.roverLight

        bottomBorder.backgroundColor = RoverColors.roverDark.withAlphaComponent(0.1)
        
        leftArrow.setImage(UIImage(named: "arrow-left"), for: .normal)
        rightArrow.setImage(UIImage(named: "arrow-right"), for: .normal)
        
        addSubview(headLargeTitle)
        addSubview(headSmallTitle)
        addSubview(leftArrow)
        addSubview(rightArrow)
        addSubview(bottomBorder)
        
        headLargeTitle.translatesAutoresizingMaskIntoConstraints = false
        headSmallTitle.translatesAutoresizingMaskIntoConstraints = false
        leftArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headLargeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headLargeTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            headSmallTitle.leadingAnchor.constraint(equalTo: headLargeTitle.leadingAnchor),
            headSmallTitle.bottomAnchor.constraint(equalTo: headLargeTitle.topAnchor, constant: -8),
            
            leftArrow.topAnchor.constraint(equalTo: rightArrow.topAnchor),
            leftArrow.trailingAnchor.constraint(equalTo: rightArrow.leadingAnchor, constant: 12),
            
            rightArrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightArrow.centerYAnchor.constraint(equalTo: headLargeTitle.centerYAnchor),
            
            bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func configureTableHead(with viewModel: CamerasViewModel) {
        leftArrow.addTarget(self, action: #selector(self.minusDay), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(self.plusDay), for: .touchUpInside)
        updateHeader()
    }
    
    @objc
    private func plusDay() {
        guard let viewModel = viewModel else { return }
        viewModel.selectedSol += 1
        updateHeader()
    }
    
    @objc
    private func minusDay() {
        guard let viewModel = viewModel else { return }
        viewModel.selectedSol -= 1
        updateHeader()
    }
}
