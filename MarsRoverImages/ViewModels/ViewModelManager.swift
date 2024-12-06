//
//  ViewModelManager.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 05.12.2024.
//

final class ViewModelManager {
    let settingsViewModel = SettingsViewModel()
    let camerasViewModel = CamerasViewModel.sharedInstance
    
    init() {
        settingsViewModel.delegate = camerasViewModel
    }
}
