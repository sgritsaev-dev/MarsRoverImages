//
//  MenuTabBarController.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 18.11.2024.
//

import UIKit

final class MenuTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
    }
    
    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.cameras, .settings]
        tabBar.backgroundColor = RoverColors.roverWhite
        tabBar.barTintColor = RoverColors.roverWhite
        tabBar.isTranslucent = false
        tabBar.tintColor = RoverColors.roverPurple
        tabBar.unselectedItemTintColor = RoverColors.roverDark
        self.viewControllers = dataSource.map {
            switch $0 {
            case .cameras:
                let CamerasViewController = CamerasViewController()
                return UINavigationController(rootViewController: CamerasViewController)
            case .settings:
                let settingsViewController = SettingsViewController()
                return UINavigationController(rootViewController: settingsViewController)
            }
        }
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.setTitleTextAttributes([.font: RoverFonts.tabBarFont ?? UIFont.systemFont(ofSize: 11)], for: .normal)
            $1.tabBarItem.image = UIImage(named: dataSource[$0].icons)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5)
        }
    }
}

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
