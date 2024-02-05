// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftVersionCompare",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v7),
        .tvOS(.v13)
    ],
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
    ],
    swiftLanguageVersions: [.v5]
)
