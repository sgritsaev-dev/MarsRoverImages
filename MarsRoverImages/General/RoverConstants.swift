//
//  RoverFont.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 18.11.2024.
//

import UIKit

final class RoverFonts: UIFont, @unchecked Sendable {
    static let tabBarFont = UIFont(name: "Helvetica", size: 11)
    static let settingsFont = UIFont(name: "Helvetica", size: 16)
    static let detailsSmallFont = UIFont(name: "Helvetica", size: 8)
    static let detailsLargeFont = UIFont(name: "Helvetica", size: 13)
    static let headLargeFont = UIFont(name: "Helvetica-Bold", size: 34)
    static let headSmallFont = UIFont(name: "Helvetica-Bold", size: 11)
    static let camerasSectionFont = UIFont(name: "Helvetica-Bold", size: 16)
}

final class RoverColors: UIColor, @unchecked Sendable {
    static let roverPurple = #colorLiteral(red: 0.429906249, green: 0.0004911000724, blue: 1, alpha: 1)
    static let roverWhite = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
    static let roverDark = #colorLiteral(red: 0.163897872, green: 0.1715083122, blue: 0.2406626642, alpha: 1)
    static let roverLight = #colorLiteral(red: 0.7228357196, green: 0.7613902688, blue: 0.8000419736, alpha: 1)
}
