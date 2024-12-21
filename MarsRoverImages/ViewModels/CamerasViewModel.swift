//
//  CamerasViewModel.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 21.12.2024.
//

import Foundation

final class CamerasViewModel {
    // MARK: - Public properties
    public weak var delegate: CamerasViewModelDelegate?
    public var groupedPhotos: [GroupedPhotos]? {
        didSet {
            delegate?.didFetchPhotos()
        }
    }
    public var selectedCamera: Camera? {
        didSet {
            cancelDispatchWorkItems()
            guard let groupedPhotos = groupedPhotos else { return }
            if selectedCamera != nil {
                selectedCameraPhotos = groupedPhotos.first(where: { $0.camera == selectedCamera})
            }
        }
    }
    public var selectedCameraPhotos: GroupedPhotos?
    public var selectedRover: Rover {
        didSet {
            cancelDispatchWorkItems()
            delegate?.didChangeRover()
        }
    }
    public var selectedSol: Int {
        didSet {
            cancelDispatchWorkItems()
            delegate?.didChangeSol()
        }
    }
    public var workItems = [DispatchWorkItem]()
    
    // MARK: - Private properties
    private let networkService = RoversPhotoNetworkService()
    
    // MARK: - Initializers
    init(selectedRover: Rover = Rover(roverName: .curiosity), selectedSol: Int = 1000) {
        self.selectedRover = selectedRover
        self.selectedSol = selectedSol
    }
    
    // MARK: - Public methods
    public func fetchPhotos(rover: Rover, sol: Int, completion: @escaping ([GroupedPhotos]?) -> ()) {
        let workItem = DispatchWorkItem {
            self.networkService.requestRoversInfo(rover: rover, sol: sol) { data, error in
                if error != nil {
                    completion(nil)
                    return
                } else if let photos = data {
                    var groupedResult = [GroupedPhotos]()
                    photos.photos.forEach { photo in
                        if let index = groupedResult.firstIndex(where: { $0.camera?.name == photo.camera.name }) {
                            groupedResult[index].photos.append(photo)
                        } else {
                            groupedResult.append(GroupedPhotos(photos: [photo], camera: photo.camera))
                        }
                    }
                    self.groupedPhotos = groupedResult
                    completion(groupedResult)
                } else {
                    completion(nil)
                }
            }
        }
        addDispatchWorkItem(workItem: workItem)
        DispatchQueue.global().async(execute: workItem)
    }
}

// MARK: - SettingsViewModelDelegate
extension CamerasViewModel: SettingsViewModelDelegate {
    internal func didSelectRover(_ rover: Rover) {
        selectedRover = rover
    }
}

// MARK: - DispatchWorkItemDelegate
extension CamerasViewModel: DispatchWorkItemDelegate {
    internal func cancelDispatchWorkItems() {
        workItems.forEach { $0.cancel() }
    }
    
    internal func addDispatchWorkItem(workItem: DispatchWorkItem) {
        self.workItems.append(workItem)
    }
}

// MARK: Protocols
protocol CamerasViewModelDelegate: AnyObject {
    func didFetchPhotos()
    func didChangeRover()
    func didChangeSol()
}

protocol DispatchWorkItemDelegate: AnyObject {
    func addDispatchWorkItem(workItem: DispatchWorkItem)
    func cancelDispatchWorkItems()
}
