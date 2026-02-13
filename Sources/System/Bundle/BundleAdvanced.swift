//
//  BundleAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

import Foundation

public extension Bundle {
    
    var version: (release: String?, build: String?) { (
        infoDictionary?["CFBundleShortVersionString"] as? String,
        infoDictionary?["CFBundleVersion"] as? String
    ) }

}

public extension Bundle {

    static func getModuleBundle(fallback: Bundle) -> Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return fallback
        #endif
    }

}
