// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "ADCoordinator",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "ADCoordinator",
            targets: ["ADCoordinator"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ADCoordinator",
            dependencies: [],
            path: "ADCoordinator/Classes"
        ),
    ]
)
