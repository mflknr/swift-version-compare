//
//  ContentView.swift
//  SemanticVersionCompareExample
//
//  Created by Marius Hötten-Löns on 07.01.21.
//

import SwiftUI
import SwiftVersionCompare

struct ContentView: View {
    @State var versionAString = ""
    @State var versionBString = ""

    var versionCompareResultString: String {
        guard
            let versionA = Version(versionAString),
            let versionB = Version(versionBString) else {
            return "Versions are not valid."
        }

        if versionA === versionB {
            return "Versions are strictly equal."
        } else if versionA == versionB {
            return "Version are equal."
        } else if versionA > versionB {
            return "Version A is greater than Version B."
        } else if versionA >= versionB {
            return "Version A is greater than or equal to Version B."
        } else if versionA < versionB {
            return "Version A is less than Version B."
        } else if versionA <= versionB {
            return "Version A is less than or equal to Version B."
        } else {
            return "Unknown"
        }
    }

    var severityResultString: String {
        guard
            let versionA = Version(versionAString),
            let versionB = Version(versionBString) else {
            return "Versions are not valid."
        }

        switch versionA.compare(with: versionB) {
        case .major:
            return "Version B is a major update to Version A."
        case .minor:
            return "Version B is a minor update to Version A."
        case .patch:
            return "Version B is a patch update to Version A."
        case .extensions:
            return "Difference in build meta info."
        case .noUpdate:
            return "No update between the versions detected."
        }
    }

    var compatibleResultString: String {
        guard
            let versionA = Version(versionAString),
            let versionB = Version(versionBString) else {
            return "Versions are not valid."
        }

        if versionA.isCompatible(with: versionB) {
            return "B is compatible with A."
        } else {
            return "B is not compatible with A."
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Version A", text: $versionAString)
                    TextField("Version B", text: $versionBString)
                }

                Section(
                    header: Text("Operator")
                ) {
                    Text("\(versionCompareResultString)")
                }

                Section(
                    header: Text("Severity")
                ) {
                    Text("\(severityResultString)")
                }

                Section(
                    header: Text("Compatible")
                ) {
                    Text("\(compatibleResultString)")
                }
            }
            .navigationTitle("SwiftVersionCompare")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
