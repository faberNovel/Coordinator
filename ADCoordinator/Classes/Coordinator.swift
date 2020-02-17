//
//  Coordinator.swift
//  ADCoordinator
//
//  Created by Pierre Felgines on 14/02/2020.
//

import Foundation

extension UIWindow: NativeNavigator {}
extension UIViewController: NativeNavigator {}

public typealias NativeNavigatorObject = NativeNavigator & NSObject

open class Coordinator {

    public private(set) var children: [Coordinator] = []
    public private(set) weak var parent: Coordinator?

    public init() {}

    public func bindToLifecycle(of nativeNavigator: NativeNavigatorObject) {
        parent?.registerDeallocCallback(of: nativeNavigator, to: self)
    }
}

extension Coordinator: Equatable {

    public static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
}

// This extension add handy methods to manipulate children array
extension Coordinator {

    public func addChild(_ coordinator: Coordinator) {
        coordinator.parent = self
        children.append(coordinator)
    }

    public func removeChild(_ coordinator: Coordinator) {
        children.removeAll { $0 == coordinator }
        coordinator.parent = nil
    }

    private func registerDeallocCallback(of nativeNavigator: NativeNavigatorObject, to child: Coordinator) {
        nativeNavigator.registerCallbackForDealloc { [weak child, weak self] in
            if let childToRemove = child {
                self?.removeChild(childToRemove)
            }
        }
    }
}
