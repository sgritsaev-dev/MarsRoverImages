//
//  RoversInfoResults.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 23.11.2024.
//

struct Photos: Decodable {
    let photos: [Photo]
    
    struct Photo: Decodable {
        let id: Int
        let imgSrc: String
        let earthDate: String
        let camera: Camera
        
        enum CodingKeys: String, CodingKey {
            case id
            case imgSrc = "img_src"
            case earthDate = "earth_date"
            case camera
        }
    }
    
    struct Camera: Decodable {
        let name: String
    }
}

struct GroupedPhotos: Decodable {
    let name: String
    var photos: [Photo]
    
    struct Photo: Decodable {
        let imgSrc: String
        let id: Int
        let earthDate: String
    }
}
