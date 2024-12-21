//
//  PhotosModel.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

public struct GroupedPhotos: Decodable, Equatable {
    public var photos: [Photo]
    public let camera: Camera?
}

public struct Photos: Decodable {
    public let photos: [Photo]
}

public struct Photo: Decodable, Equatable {
    // ID number of the image fetched.
    public let id: Int
    // Image source of the image for loading.
    public let imgSrc: String
    // Relevant earth date when the image was taken.
    public let earthDate: String
    // Info about the camera which took the image.
    public let camera: Camera
    
    public enum CodingKeys: String, CodingKey {
        case id
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case camera
    }
}

public struct Camera: Decodable, Equatable {
    // Name of the camera.
    public let name: String
}
