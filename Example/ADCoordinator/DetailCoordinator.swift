//
//  DetailCoordinator.swift
//  ADCoordinator_Example
//
//  Created by Pierre Felgines on 17/02/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import ADCoordinator

class DetailCoordinator: Coordinator {

    private unowned var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public

    func start(animated: Bool) {
        let viewController = DetailViewController()
        navigationController.pushViewController(viewController, animated: animated)
        bindToLifecycle(of: viewController)
    }
}
