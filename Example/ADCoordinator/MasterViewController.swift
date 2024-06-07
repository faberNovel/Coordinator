//
//  MasterViewController.swift
//  ADCoordinator_Example
//
//  Created by Pierre Felgines on 17/02/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

@MainActor
protocol MasterViewControllerDelegate: AnyObject {
    func masterViewControllerDidRequestPresent()
    func masterViewControllerDidRequestPush()
}

class MasterViewController: UIViewController {

    weak var delegate: MasterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        title = "Master"

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
        delegate?.masterViewControllerDidRequestPush()
    }

    @objc private func presentSelected() {
        delegate?.masterViewControllerDidRequestPresent()
    }
}
