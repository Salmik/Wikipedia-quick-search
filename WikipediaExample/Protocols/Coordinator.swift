//
//  Coordinator.swift
//  WikipediaExample
//
//  Created by Zhanibek Lukpanov on 09.05.2021.
//

import UIKit
import WikipediaKit

enum Event {
    case detailScreen(model: WikipediaArticlePreview)
}

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func start()
    func eventOccured(with type: Event)
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
