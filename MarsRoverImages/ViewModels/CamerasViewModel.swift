//
//  CamerasViewModel.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 04.12.2024.
//

import Foundation

final class CamerasViewModel {
    
    static let sharedInstance = CamerasViewModel()
    weak var delegate: CamerasViewModelDelegate?
    
    var groupedPhotos: [GroupedPhotos]? {
        didSet {
            delegate?.didFetchPhotos()
        }
    }
    var selectedCamera: Camera? {
        didSet {
            guard let groupedPhotos = groupedPhotos else { return }
            if selectedCamera != nil {
                selectedCameraPhotos = groupedPhotos.first(where: { $0.camera == selectedCamera})
            }
        }
    }
    var selectedCameraPhotos: GroupedPhotos?
    var selectedRover: Rover {
        didSet {
            delegate?.didChangeRover()
        }
    }
    var selectedSol: Int {
        didSet {
            delegate?.didChangeSol()
        }
    }
    
    private var networkService = RoversPhotoNetworkService()

    init(selectedRover: Rover = Rover(roverName: .curiosity), selectedSol: Int = 1000) {
        self.selectedRover = selectedRover
        self.selectedSol = selectedSol
    }
    
    func fetchPhotos(rover: Rover, sol: Int, completion: @escaping ([GroupedPhotos]?) -> ()) {
        networkService.requestRoversInfo(rover: rover, sol: sol) { data, error in
            if error != nil {
                completion(nil)
                return
            }
            do {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                let results = try decoder.decode(Photos.self, from: data)
                
                var groupedResult = [GroupedPhotos]()
                results.photos.forEach { photo in
                    if let index = groupedResult.firstIndex(where: { $0.camera?.name == photo.camera.name }) {
                        groupedResult[index].photos.append(photo)
                    } else {
                        groupedResult.append(GroupedPhotos(camera: photo.camera, photos: [photo]))
                    }
                }
                self.groupedPhotos = groupedResult
                completion(groupedResult)
            } catch {
                completion(nil)
            }
        }
    }
}

extension CamerasViewModel: SettingsViewModelDelegate {
    func didSelectRover(_ rover: Rover) {
        selectedRover = rover
    }
}

protocol CamerasViewModelDelegate: AnyObject {
    func didFetchPhotos()
    func didChangeRover()
    func didChangeSol()
}
