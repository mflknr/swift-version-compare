protocol SemanticVersionComparable: Comparable {
    var major: UInt { get }
    var minor: UInt { get }
    var patch: UInt { get }

    var extensions: [String]? { get }
}

// MARK: - Comparable

extension SemanticVersionComparable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.major == rhs.major &&
        lhs.minor == rhs.minor &&
        lhs.patch == rhs.patch &&
          lhs.extensions?.isEmpty == rhs.extensions?.isEmpty
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        guard lhs != rhs else { return false }

        if lhs.major < rhs.major {
            return true
        } else if lhs.major == rhs.major, lhs.minor < rhs.minor {
            return true
        } else if lhs.major == rhs.major, lhs.minor == rhs.minor, lhs.patch < rhs.patch {
            return true
        } else if
            lhs.major == rhs.major,
            lhs.minor == rhs.minor,
            lhs.patch == rhs.patch,
            lhs.extensions != nil,
            rhs.extensions == nil {
            return true
        } else {
            return false
        }
    }

    static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs == rhs || lhs < rhs
    }

    static func > (lhs: Self, rhs: Self) -> Bool {
        guard lhs != rhs else { return false }

        if lhs.major > rhs.major {
            return true
        } else if lhs.major == rhs.major, lhs.minor > rhs.minor {
            return true
        } else if lhs.major == rhs.major, lhs.minor == rhs.minor, lhs.patch > rhs.patch {
            return true
        } else if
            lhs.major == rhs.major,
            lhs.minor == rhs.minor,
            lhs.patch == rhs.patch,
            lhs.extensions == nil,
            rhs.extensions != nil {
            return true
        } else {
            return false
        }
    }

    static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs == rhs || lhs > rhs
    }
}

// MARK: - Operations

extension SemanticVersionComparable {
    /// A Boolean value indicating whether the version is compatible with a given different version.
    /// - Parameter version: An object that conforms to the `SemanticVersionComparable`protocol.
    /// - Returns: A boolean indication the compatibility.
    func isCompatible(with version: Self) -> Bool {
        self.major == version.major
    }
}

// MARK: - Accessor

extension SemanticVersionComparable {
    var absoluteString: String {
        [versionCode, `extension`]
            .compactMap { $0 }
            .joined(separator: "-")
    }

    var versionCode: String {
        [major, minor, patch]
            .map(String.init)
            .joined(separator: ".")
    }

    var `extension`: String? {
        extensions?.joined(separator: ".")
    }
}

