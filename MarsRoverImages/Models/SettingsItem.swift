//
//  SettingsItem.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 22.11.2024.
//

enum Rover: String, CaseIterable {
    case curiosity = "Curiosity"
    case spirit = "Spirit"
    case opportunity = "Opportunity"
    case perseverance = "Perseverance"
    
    var lowercase: String {
        return self.rawValue.lowercased()
    }
}

final class SettingsItem {
    let roverName: Rover
    var isSelected: Bool = false
    
    init(roverName: Rover, isSelected: Bool) {
        self.roverName = roverName
        self.isSelected = isSelected
    }
}

