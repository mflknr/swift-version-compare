// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-version-compare",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v7),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "VersionCompare",
            targets: [
                "VersionCompare"
            ]
        )
    ],
    targets: [
        .target(
            name: "VersionCompare",
            path: "Sources",
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy")
            ]
        ),
        .testTarget(
            name: "VersionCompareTests",
            dependencies: [
                "VersionCompare"
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
