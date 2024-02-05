# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2024-02-03

### Changed

- `swift-tools-version` to `5.9.2` for the package manifest and tools

### Removed

- generated .xcodeproj file
- codecov

## [1.1.0] - 2021-10-02

### Added

- Support for [CocoaPods](https://cocoapods.org).

### Changed

- Updated documentation for more clarity.

## [1.0.4] - 2021-07-31

### Added

- A workflow to generate documentation on the `documentation` branch when changes are pushed to `main`.
- A workflow to create a release when a new tag is pushed to `main`.

### Changed

- The `Check build and tests` workflow now builds for Swift 5.3 and 5.4, macOS and ubuntu. Tests will run under macOS only.
- Moved `docs/` folder to dedicated `documentation` branch.

### Fixed

- Failed compilation with `VersionValidationError` s localized error description.

### Removed

- Linux support for test target.

## [1.0.3] - 2021-07-22

### Added

- `CHANGELOG.md` for a better overview regarding all releases.
- Localized error description to error type for more clarity.

### Changed

- Renamed `Error` to `VersionValidationError` for better understanding when parsing an invalid string.
- Updated and enhanced documentation on public methods and properties.

## [1.0.2] - 2021-03-30

Fixed regex pattern for checking if string is alpha numeric or numeric. Removed minor typos and updated documentation.

## [1.0.1] - 2021-03-30

Added missing documentation. Removed redundant methods.

## [1.0.0] - 2021-03-30

Create a version object using a string or from component building a semantic version! You can also use the SemanticVersionComparable protocol to compare to version as much as you like or implement your own version object.

## [0.6.0] - 2021-01-07

Initial published setup of this package. Create a version from string, using major, minor, patch and extensions, from Bundle or from ProcessInfo. Compare two versions with common operators (==, ===, <, <=, >, >=) or get the severity of an update.
