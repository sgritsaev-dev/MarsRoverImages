//
//  RoverModel.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 04.12.2024.
//

struct Rover: Equatable {
    let roverName: RoverName
    
    enum RoverName: String, CaseIterable {
        case curiosity = "Curiosity"
        case spirit = "Spirit"
        case opportunity = "Opportunity"
        case perseverance = "Perseverance"
        
        var lowercase: String {
            return self.rawValue.lowercased()
        }
    }
}
