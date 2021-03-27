# SwiftVersionCheck

A small package for comparing and utilizing versions conforming to [SemVer](https://semver.org).

# Installation

Swift Package Manager:

```swift
package(url: https://github.com/nihilias/SwiftVersionCompare.git", from: "1.0.0"))
```

# Usage

For detailed implenentation information see auto-generated [documentation]().

```swift
// use the version core identifier for initialization
let versionOne = Version(1, 0, 0)
let versionTwo = Version(
    major: 1,
    minor: 0,
    patch: 0,
    prerelease: [.alpha],
    build: ["1"]
)

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


