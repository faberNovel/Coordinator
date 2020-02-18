//
//  DeallocObserver.swift
//  ADCoordinator
//
//  Created by Pierre Felgines on 14/02/2020.
//

import Foundation

/**
 * An instance of this class emits an event when it is deallocated
 */
final class DeallocObserver {

    private var callback: () -> Void

    /**
     * - parameter callback: The callback called when self is deallocated
     */
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }

    /**
    * Removes the current callback
    */
    func invalidate() {
        callback = {}
    }

    deinit {
        callback()
    }
}
