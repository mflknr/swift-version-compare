# swift-version-compare

[![build](https://github.com/mflknr/swift-version-compare/workflows/checks/badge.svg)](https://github.com/mflknr/swift-version-compare/actions/workflows/checks.yml)
[![doccov](https://mflknr.github.io/swift-version-compare/badge.svg?sanitize=true)](https://mflknr.github.io/swift-version-compare/)
[![licence](https://img.shields.io/github/license/mflknr/swift-version-compare)](https://github.com/mflknr/swift-version-compare/blob/main/LICENSE)

A package introducing a `Version` object implementing the  `SemanticVersionComparable` protocol for comparing versions conforming to [SemVer](https://semver.org). 

# Installation

#### Swift Package Manager:

```swift
.package(url: https://github.com/mflknr/swift-version-compare.git", from: "2.0.0"))
```

# Usage

For detailed implementation information see [documentation](https://mflknr.github.io/swift-version-compare/).

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


