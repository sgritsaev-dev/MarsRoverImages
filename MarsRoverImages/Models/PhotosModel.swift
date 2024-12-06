//
//  RoverImagesModel.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 04.12.2024.
//

struct GroupedPhotos: Decodable, Equatable {
    let camera: Camera?
    var photos: [Photo]
}

struct Photos: Decodable {
    let photos: [Photo]
}

struct Photo: Decodable, Equatable {
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

struct Camera: Decodable, Equatable {
    let name: String
}
