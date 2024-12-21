//
//  String+dateToRus.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

import UIKit

extension String {
    public var dateToRus: String {
        let components = self.components(separatedBy: "-")
        if components.count == 3 {
            return "\(components[2]).\(components[1]).\(components[0])"
        } else {
            return self
        }
    }
}
