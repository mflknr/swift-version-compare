# SwiftVersionCheck

A small package for comparing and using versions conforming to [SemVer](https://semver.org).

Following features are and will be implemented:

- [x] Create a version from major, minor, patch and extension information.
- [x] Create a version from string using `LosslessStringConvertible` or `ExpressibleByStringLiteral` .
- [x] Compare versions using `Equatable` and `Comparable` with the known operators `==, ===, <, <=, > and >=`.
- [x] Compare versions and get a result type defining the severity of the version difference (e. g. major-update).
- [ ] Utilize ranges for a greater variaty of comparisons.
- [x] Extend `Bundle` and `ProcessInfo` for easy usage.
- [x] Open documentation.
- [ ] Implement extension for `Codable` and `Hashable`.

# Installation

Swift Package Manager:

```
package(url: https://github.com/nihilias/SwiftVersionCompare.git", from: "1.0.0"))
```

# Usage

For detailed implenentation information see auto-generated [documentation]().

```
// use the version identifier for initialization
let versionOne = Version(1, 0, 0)
let versionTwo = Version(
    major: 1,
    minor: 0,
    patch: 0
)

// use strings
// use `ExpressibleByStringLiteral` with caution, because it's fatal if string is not `SemVer` version
let versionThreeA: Version = "1.0.0" 
let versionThreeB: Version = Version("1.0.0")

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
```


