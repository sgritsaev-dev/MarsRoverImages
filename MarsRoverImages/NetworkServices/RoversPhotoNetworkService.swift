//
//  RandomPicsNetworkService.swift
//  CollectionPinterest
//
//  Created by Сергей Грицаев on 15.11.2024.
//

import Foundation
import UIKit

final class RoversPhotoNetworkService {
    
    let myApiKey = "huENgeG0NEoHNsMQPTIFNcPJ8ugPNd9BWnqhFeRe"
    
    func requestRoversInfo(rover: Rover, sol: Int, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover.roverName.lowercase)/photos?sol=\(sol)&api_key=\(myApiKey)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, error)
        }
        task.resume()
    }
}
