//
//  Debug.swift
//  RxPullToRefreshUITests
//
//  Created by kojirof on 2018/12/24.
//  Copyright © 2018 Kojiro Futamura. All rights reserved.
//

import Foundation

/**
 Debugging
 */

func printf(_ name: String, _ value: Any?, icon: String = "ℹ️") {
    var str: String
    switch value {
    case is Bool:
        str = (value as? Bool ?? false) ? "🔵 true" : "🔴 false"
    default:
        str = String(describing: value ?? "nil")
    }
    print("    \(icon) \(name):".lpad() + str)
}

internal extension String {
    func lpad() -> String {
        return self.padding(toLength: 32, withPad: " ", startingAt: 0)
    }
}
