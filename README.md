# SwiftVersionCompare

![platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg)
![languages](https://img.shields.io/badge/swift-5.0%20%7C%205.1%20%7C%205.2%20%7C%205.3-orange.svg)
[![build](https://github.com/mflknr/SwiftVersionCompare/workflows/build/badge.svg)](https://github.com/mflknr/SwiftVersionCompare/actions)
[![doccov](https://mflknr.github.io/SwiftVersionCompare/badge.svg?sanitize=true)](https://mflknr.github.io/SwiftVersionCompare/)
[![codecov](https://codecov.io/gh/mflknr/SwiftVersionCompare/branch/develop/graph/badge.svg?token=6EAG2J8DMU)](https://codecov.io/gh/mflknr/SwiftVersionCompare)

A small package introducing a `Version` object implementing the  `SemanticVersionComparable` protocol for comparing versions conforming to [SemVer](https://semver.org). 

# Installation

Swift Package Manager:

```swift
package(url: https://github.com/mflknr/SwiftVersionCompare.git", from: "1.0.0"))
```

# Usage

For detailed implenentation information see [documentation](https://mflknr.github.io/SwiftVersionCompare/).

```swift
// use the version core identifier for initialization
let versionOne = Version(1, 0, 0)
let versionTwo = Version(
    major: 1,
    minor: 0,
    patch: 0,
    prerelease: [.alpha],
    build: ["1"]
) // -> prints: "1.0.0-alpha+1"

// use strings
// use `ExpressibleByStringLiteral` with caution, because it's fatal if string is not `SemVer` version
let versionThreeA: Version? = "1.0.0" 
let versionThreeB: Version? = Version("1.0.0")

// easy initial `0.0.0` version
let initialVersion: Version = .initial

// from bundle and processInfo
let bundleVersion = Bundle.main.shortVersion
let osVersion = ProcessInfo.processInfo.comparableOperatingSystemVersion

// compare versions with usally known operators (==, ===, <, <=, >=, >)
if Version("1.0.0") > Version("0.4.0") {
    // ...
}
```


