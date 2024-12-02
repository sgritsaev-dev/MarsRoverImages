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
    
    func requestRoversInfo(rover: String, sol: Int, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos?sol=\(sol)&api_key=\(myApiKey)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        let task = createData(from: request, completion: completion)
        task.resume()
    }
    
    func createData(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
