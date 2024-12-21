//
//  SettingsViewModel.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

final class SettingsViewModel {
    // MARK: - Public properties
    public weak var delegate: SettingsViewModelDelegate?
    public var selectedRover: Rover? {
        didSet {
            guard let rover = selectedRover else { return }
            delegate?.didSelectRover(rover)
        }
    }
    public let rovers: [Rover] = Rover.RoverName.allCases.map { Rover(roverName: $0) }
    
    // MARK: - Initializers
    init(selectedRover: Rover = Rover(roverName: .curiosity)) {
        self.selectedRover = selectedRover
    }
}

// MARK: - Protocols
protocol SettingsViewModelDelegate: AnyObject {
    func didSelectRover(_ rover: Rover)
}
