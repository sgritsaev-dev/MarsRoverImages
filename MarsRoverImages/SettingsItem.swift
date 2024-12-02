//
//  SettingsItem.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 22.11.2024.
//

final class SettingsItem {
    let title: String
    var isSelected: Bool = false
    
    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
}
