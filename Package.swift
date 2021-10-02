// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftVersionCompare",
    products: [
        .library(
            name: "SwiftVersionCompare",
            targets: ["SwiftVersionCompare"]),
    ],
    targets: [
        .target(
            name: "SwiftVersionCompare",
            dependencies: []),
        .testTarget(
            name: "SwiftVersionCompareTests",
            dependencies: ["SwiftVersionCompare"]
        ),
    ]
)
