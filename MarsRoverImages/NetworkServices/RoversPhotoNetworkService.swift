//
//  RandomPicsNetworkService.swift
//  CollectionPinterest
//
//  Created by Сергей Грицаев on 15.11.2024.
//

import Foundation
import UIKit

final class RoversPhotoNetworkService {
    
    private let myApiKey = "huENgeG0NEoHNsMQPTIFNcPJ8ugPNd9BWnqhFeRe"
    
    func requestRoversInfo(rover: Rover, sol: Int, completion: @escaping (Photos?, Error?) -> Void) {
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover.roverName.lowercase)/photos?sol=\(sol)&api_key=\(myApiKey)") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { completion(nil, error) }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(Photos.self, from: data)
                    completion(result, nil) }
                catch { completion(nil, error) }
            }
        }
        task.resume()
    }
}
