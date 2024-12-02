//
//  DetailsViewControllerDelegate.swift
//  MarsRoverImages
//
//  Created by Сергей Грицаев on 02.12.2024.
//

protocol DetailsViewControllerDelegate: AnyObject {
    func didUpdateRoverOrSol(rover: String, sol: Int)
}
