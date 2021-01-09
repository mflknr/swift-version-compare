# SwiftVersionCompare

![platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg)
![languages](https://img.shields.io/badge/swift-5.0%20%7C%205.1%20%7C%205.2%20%7C%205.3-orange.svg)
[![build](https://github.com/nihilias/SwiftVersionCompare/workflows/build/badge.svg)](https://github.com/nihilias/SwiftVersionCompare/actions)
[![doccov](https://nihilias.github.io/SwiftVersionCompare/badge.svg?sanitize=true)](https://nihilias.github.io/SwiftVersionCompare/)
[![codecov](https://codecov.io/gh/nihilias/SwiftVersionCompare/branch/develop/graph/badge.svg?token=6EAG2J8DMU)](https://codecov.io/gh/nihilias/SwiftVersionCompare)

A small package for comparing and utilizing versions conforming to [SemVer](https://semver.org).

Following features are and will be implemented:

- [x] Create a version from major, minor, patch and extension information.
- [x] Create a version from string using `LosslessStringConvertible` or `ExpressibleByStringLiteral` .
- [x] Compare versions using `Equatable` and `Comparable` with the known operators `==, ===, <, <=, > and >=`.
- [x] Compare versions and get the severity of the update (e. g. major-update).
- [ ] Utilize ranges for a greater variaty of comparisons.
- [x] Extend `Bundle` and `ProcessInfo` for easy usage.
- [x] Open documentation.
- [ ] Extend `Codable` and `Hashable`.

# Installation

Swift Package Manager:

```swift
package(url: https://github.com/nihilias/SwiftVersionCompare.git", from: "0.6.0"))
```

# Usage

For detailed implenentation information see auto-generated [documentation]().

```swift
// use the version identifier for initialization
let versionOne = Version(1, 0, 0)
let versionTwo = Version(
    major: 1,
    minor: 0,
    patch: 0
)

// use strings
// use `ExpressibleByStringLiteral` with caution. it's fatal if the string is not a `SemVer` version
let versionThreeA: Version = "1.0.0" 
let versionThreeB: Version = Version("1.0.0")

// using the optional type is safe
let versionFourA: Version? = "1.0.0"
let versionFourB: Version? = Version("1.0.0")

// easy initial `0.0.0` version
let initialVersion: Version = .initial

// from bundle and processInfo
let bundleVersion = Bundle.main.shortVersion
let osVersion = ProcessInfo.processInfo.comparableOperatingSystemVersion

// compare versions with usally known operators (==, ===, <, <=, >=, >)
if Version("1.0.0") > Version("0.4.0") {
    // ...
}

// compare versions and get update severity
let currentVersion = Version("0.6.0")
let newVersion = Version("1.0.0")

if currentVersion.severity(to: newVersion) == .major {
    // ...
}
```


