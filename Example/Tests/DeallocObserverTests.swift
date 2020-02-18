//
//  DeallocObserverTests.swift
//  ADCoordinator_Example
//
//  Created by Pierre Felgines on 17/02/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import ADCoordinator

class DeallocObserverTests: XCTestCase {

    func testDeallocObserver() {
        // Given
        let expectation = self.expectation(description: "observer is deallocated")
        var deallocObserver = DeallocObserver {
            expectation.fulfill()
        }
        _ = deallocObserver // remove compiler warning for never used variable

        // When
        deallocObserver = DeallocObserver { } // dealloc previous instance

        // Then
        waitForExpectations(timeout: 0.1)
    }

    func testDeallocObserverInvalidation() {
        // Given
        let expectation = self.expectation(description: "observer is deallocated")
        expectation.isInverted = true
        var deallocObserver = DeallocObserver {
            expectation.fulfill()
        }

        _ = deallocObserver // remove compiler warning for never used variable

        // When
        deallocObserver.invalidate()
        deallocObserver = DeallocObserver { } // dealloc previous instance

        // Then
        waitForExpectations(timeout: 0.1)
    }
}
