//
//  MenuTabBarController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

import UIKit

final class MenuTabBarController: UITabBarController {
    // MARK: - Private properties
    private var camerasViewController: CamerasViewController?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Private methods
    private func setupTabBar() {
        setupAppearance()
        let dataSource: [TabBarItem] = [.cameras, .settings]
        let camerasViewController = CamerasViewController()
        let settingsViewController = SettingsViewController()
        self.viewControllers = dataSource.map {
            switch $0 {
            case .cameras:
                return UINavigationController(rootViewController: camerasViewController)
            case .settings:
                settingsViewController.viewModel.delegate = camerasViewController.viewModel
                return UINavigationController(rootViewController: settingsViewController)
            }
        }
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(named: dataSource[$0].icons)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5)
        }
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = RoverColors.roverWhite
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = RoverColors.roverDark
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: RoverColors.roverDark, .font: RoverFonts.tabBarFont ?? UIFont.systemFont(ofSize: 11)]
        itemAppearance.selected.iconColor = RoverColors.roverPurple
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: RoverColors.roverPurple, .font: RoverFonts.tabBarFont ?? UIFont.systemFont(ofSize: 11)]
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - TabBarItem
extension MenuTabBarController {
    private enum TabBarItem {
        case cameras
        case settings
        var title: String {
            switch self {
            case .cameras:
                return "Камеры"
            case .settings:
                return "Настройки"
            }
        }
        var icons: String {
            switch self {
            case .cameras:
                return "quality"
            case .settings:
                return "prefs"
            }
        }
    }
}
