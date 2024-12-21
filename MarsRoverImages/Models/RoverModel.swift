//
//  RoverModel.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

public struct Rover: Equatable {
    public let roverName: RoverName
    
    public enum RoverName: String, CaseIterable {
        case curiosity = "Curiosity"
        case spirit = "Spirit"
        case opportunity = "Opportunity"
        case perseverance = "Perseverance"
        
        public var lowercase: String {
            return self.rawValue.lowercased()
        }
    }
}
