//
//  MainCoordinator.swift
//  WikipediaExample
//
//  Created by Zhanibek Lukpanov on 09.05.2021.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    func start() {
        var vc: UIViewController & Coordinating = ViewController()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func eventOccured(with type: Event) {
        switch type {
        case .detailScreen(model: let model):
            var vc: UIViewController & Coordinating = DetailsViewController(model: model)
            vc.coordinator = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }    
}
