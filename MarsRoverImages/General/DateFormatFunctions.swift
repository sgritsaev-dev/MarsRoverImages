//
//  Calculators.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 01.12.2024.
//

import UIKit

extension NSObject {
    func urlToRus(urlDate: String) -> String {
        let dateDate = stringToDate(dateFormat: "yyyy-MM-dd", date: urlDate)
        let rusDate = dateToString(dateFormat: "dd.MM.yyyy", date: dateDate)
        return rusDate
    }
    
    func stringToDate(dateFormat: String, date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        guard let date = formatter.date(from: date) else { return Date() }
        return date
    }
    
    func dateToString(dateFormat: String, date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date
    }
}
