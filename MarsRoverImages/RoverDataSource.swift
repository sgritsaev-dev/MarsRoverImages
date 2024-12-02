//
//  RoverDataSource.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 02.12.2024.
//

final class RoverDataSource {
    static let shared = RoverDataSource()
    var selectedRover: Rover = .curiosity {
        didSet {
            reloadDelegate?(selectedRover.lowercase, selectedSol)
        }
    }
    var reloadDelegate: ((String, Int) -> Void)?
    var selectedSol: Int = 1000 {
        didSet {
            reloadDelegate?(selectedRover.lowercase, selectedSol)
        }
    }
}
