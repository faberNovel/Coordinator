// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ADCoordinator",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10)
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
