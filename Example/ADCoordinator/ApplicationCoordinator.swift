//
//  ApplicationCoordinator.swift
//  ADCoordinator_Example
//
//  Created by Pierre Felgines on 17/02/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import ADCoordinator

class ApplicationCoordinator: Coordinator, MasterViewControllerDelegate {

    // Note the `unowned` keyword here.
    // We do not own the navigation controller, the view hierarchy does.
    private unowned var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public

    func start() {
        let viewController = MasterViewController()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
        // Remove self from parent if viewController is deallocated
        bindToLifecycle(of: viewController)
    }

    // MARK: - MasterViewControllerDelegate

    func masterViewControllerDidRequestPresent() {
        sanityCheck()
        let navigationController = UINavigationController()
        let coordinator = DetailCoordinator(navigationController: navigationController)
        addChild(coordinator)
        coordinator.start(animated: false)
        self.navigationController.present(navigationController, animated: true)
    }

    func masterViewControllerDidRequestPush() {
        sanityCheck()
        let coordinator = DetailCoordinator(navigationController: navigationController)
        addChild(coordinator)
        coordinator.start(animated: true)
    }

    // MARK: - Private

    private func sanityCheck() {
        precondition(children.isEmpty, "Children should always be empty")
    }
}
