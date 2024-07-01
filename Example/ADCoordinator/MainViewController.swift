//
//  MainViewController.swift
//  ADCoordinator_Example
//
//  Created by Pierre Felgines on 17/02/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

@MainActor
protocol MainViewControllerDelegate: AnyObject {
    func mainViewControllerDidRequestPresent()
    func mainViewControllerDidRequestPush()
}

class MainViewController: UIViewController {

    weak var delegate: MainViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        title = "Main"

        let pushButton = UIButton(type: .system)
        pushButton.setTitle("Push detail", for: .normal)
        pushButton.addTarget(self, action: #selector(pushSelected), for: .touchUpInside)

        let presentButton = UIButton(type: .system)
        presentButton.setTitle("Present detail", for: .normal)
        presentButton.addTarget(self, action: #selector(presentSelected), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [pushButton, presentButton])
        stackView.axis = .vertical
        stackView.spacing = 30.0
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Private

    @objc private func pushSelected() {
        delegate?.mainViewControllerDidRequestPush()
    }

    @objc private func presentSelected() {
        delegate?.mainViewControllerDidRequestPresent()
    }
}
