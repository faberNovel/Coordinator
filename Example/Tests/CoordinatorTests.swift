//
//  CoordinatorTests.swift
//  ADCoordinator_Example
//
//  Created by Pierre Felgines on 17/02/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import ADCoordinator

class ParentCoordinator: Coordinator {}

class ChildCoordinator: Coordinator {}

class CoordinatorTests: XCTestCase {

    @MainActor
    func testAddChild() {
        // Given
        let parent = ParentCoordinator()
        let child = ChildCoordinator()
        XCTAssertTrue(parent.children.isEmpty)
        XCTAssertNil(child.parent)

        // When
        parent.addChild(child)

        // Then
        XCTAssertEqual(parent.children, [child])
        XCTAssertEqual(child.parent, parent)
    }

    @MainActor
    func testChildDoNotRetainParent() {
        // Given
        var parent = ParentCoordinator()
        let child = ChildCoordinator()
        parent.addChild(child)
        XCTAssertEqual(parent.children, [child])
        XCTAssertEqual(child.parent, parent)

        // When
        parent = ParentCoordinator() // dealloc previous instance

        // Then
        XCTAssertNil(child.parent)
    }

    @MainActor
    func testRemoveChild() {
        // Given
        let parent = ParentCoordinator()
        let child1 = ChildCoordinator()
        let child2 = ChildCoordinator()
        parent.addChild(child1)
        parent.addChild(child2)
        XCTAssertEqual(parent.children, [child1, child2])

        // When
        parent.removeChild(child1)

        // Then
        XCTAssertEqual(parent.children, [child2])
        XCTAssertNil(child1.parent)
        XCTAssertEqual(child2.parent, parent)
    }

    @MainActor
    func testBindToLifecycle() {
        // Given
        let parent = ParentCoordinator()
        let child = ChildCoordinator()
        parent.addChild(child)

        autoreleasepool {
            var viewController = UIViewController()

            child.bindToLifecycle(of: viewController)

            // When
            viewController = UIViewController() // dealloc previous instance
        }

        // Then
        XCTAssertTrue(parent.children.isEmpty)
    }

    @MainActor
    func testBindToLifecycleWithOtherObject() {
        // Given
        let viewController2 = UIViewController()
        let parent = ParentCoordinator()
        let child = ChildCoordinator()
        parent.addChild(child)

        autoreleasepool {
            var viewController1 = UIViewController()

            child.bindToLifecycle(of: viewController1)

            // When
            child.bindToLifecycle(of: viewController2)
            viewController1 = UIViewController() // dealloc previous instance
        }

        // Then
        XCTAssertEqual(parent.children, [child])
    }

    @MainActor
    func testBindToLifecycleWithParentChange() {
        // Given
        let parent1 = ParentCoordinator()
        let parent2 = ParentCoordinator()
        let child = ChildCoordinator()
        parent1.addChild(child)

        autoreleasepool {
            var viewController = UIViewController()

            child.bindToLifecycle(of: viewController)

            // When
            parent1.removeChild(child)
            parent2.addChild(child)

            viewController = UIViewController() // dealloc previous instance
        }

        // Then
        XCTAssertTrue(parent1.children.isEmpty)
        XCTAssertTrue(parent2.children.isEmpty)
    }
}
