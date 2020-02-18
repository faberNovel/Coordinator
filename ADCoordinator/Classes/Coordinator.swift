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

    /**
     * Stores all the children of self.
     * It allows to keep a strong reference to all children until they are removed
     */
    public private(set) var children: [Coordinator] = []

    /**
     * Stores a weak reference to the parent coordinator.
     */
    public private(set) weak var parent: Coordinator?

    /**
    * Stores the current object observed for deallocation
    */
    private weak var boundNativeNavigator: NativeNavigatorObject?

    public init() {}

    /**
     * Binds the lifecycle of self to the one of another object
     * - parameter nativeNavigator: The object to listen to deallocation to
     * - note: When the nativeNavigator object is deallocated, self is removed from it's parent children array.
     * That means the parent do not keep any reference to self, and self can be deallocated.
     */
    public func bindToLifecycle(of nativeNavigator: NativeNavigatorObject) {
        boundNativeNavigator?.removeCallbackForDealloc()
        boundNativeNavigator = nativeNavigator
        parent?.removeChild(self, onDeallocationOf: nativeNavigator)
    }
}

extension Coordinator: Equatable {

    public static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
}

// This extension add handy methods to manipulate children array
extension Coordinator {

    /**
     * Adds a child coordinator
     * - parameter coordinator: The child added to the children array.
     * - note: This method allows to keep a strong reference on the child coordinator.
     */
    public func addChild(_ coordinator: Coordinator) {
        coordinator.parent = self
        children.append(coordinator)
    }

    /**
     * Removes a child coordinator
     * - parameter coordinator: The child coordinator to remove
     * - note: This method raises an error if the child is not present in the children
     */
    public func removeChild(_ coordinator: Coordinator) {
        assert(
            children.contains(coordinator),
            "Children of \(self) do not contains child coordinator \(coordinator)"
        )
        children.removeAll { $0 == coordinator }
        coordinator.parent = nil
    }

    /**
     * Listens to deallocation of native navigator and remove child when it's deallocated
     * - parameter nativeNavigator: The object to listen deallocation to
     * - parameter coordinator: The coordinator that must be removed from children once the native
     * navigator is deallocated
     * - note: We listen to nativeNavigator deallocation and remove child reference from self once it happens.
     */
    func removeChild(_ coordinator: Coordinator,
                     onDeallocationOf nativeNavigator: NativeNavigatorObject) {
        nativeNavigator.registerCallbackForDealloc { [weak coordinator, weak self] in
            if let child = coordinator {
                self?.removeChild(child)
            }
        }
    }
}
