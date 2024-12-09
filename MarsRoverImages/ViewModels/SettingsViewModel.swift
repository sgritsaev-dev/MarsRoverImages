//
//  SettingsViewModel.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 04.12.2024.
//

final class SettingsViewModel {
    weak var delegate: SettingsViewModelDelegate?
    
    let rovers: [Rover] = Rover.RoverName.allCases.map { Rover(roverName: $0) }
    var selectedRover: Rover? {
        didSet {
            guard let rover = selectedRover else { return }
            delegate?.didSelectRover(rover)
        }
    }
    
    init(selectedRover: Rover = Rover(roverName: .curiosity)) {
        self.selectedRover = selectedRover
    }
}

protocol SettingsViewModelDelegate: AnyObject {
    func didSelectRover(_ rover: Rover)
}
