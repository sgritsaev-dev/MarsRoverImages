//
//  RandomPicsFetcher.swift
//  CollectionPinterest
//
//  Created by Сергей Грицаев on 15.11.2024.
//

import Foundation

final class RoverPhotoFetcher {
    
    var networkService = RoversPhotoNetworkService()
    
    func fetchRoverPhotos(rover: String, sol: Int, completion: @escaping (Photos?) -> ()) {
        networkService.requestRoversInfo(rover: rover, sol: sol) { (data, error) in
            if error != nil {
                completion(nil)
            }
            let results = self.decodeJSON(from: data)
            completion(results)
        }
    }
    
    private func decodeJSON(from data: Data?) -> Photos? {
        guard let data = data else { return nil }
        do {
            let decoder = JSONDecoder()
            let results = try decoder.decode(Photos.self, from: data)
            return results
        } catch {
            return nil
        }
    }
}

extension RoverPhotoFetcher {
    func fetchGroupedPhotos(rover: String, sol: Int, completion: @escaping ([GroupedPhotos]) -> ()) {
        fetchRoverPhotos(rover: rover, sol: sol) { (photos) in
            if let photos = photos {
                let groupedPhotos = photos.photos.reduce(into: [GroupedPhotos]()) { result, photo in
                    let cameraName = photo.camera.name
                    if let existingGroup = result.first(where: { $0.name == cameraName }) {
                        var updatedGroup = existingGroup
                        updatedGroup.photos.append(GroupedPhotos.Photo(imgSrc: photo.imgSrc, id: photo.id, earthDate: photo.earthDate))
                        result[result.firstIndex(where: { $0.name == cameraName })!] = updatedGroup
                    } else {
                        result.append(GroupedPhotos(name: cameraName, photos: [GroupedPhotos.Photo(imgSrc: photo.imgSrc, id: photo.id, earthDate: photo.earthDate)]))
                    }
                }
                completion(groupedPhotos)
            } else {
                completion([])
            }
        }
    }
}
