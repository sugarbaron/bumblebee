//
//  UrlAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

import Foundation

public extension URL {

    init?(_ url: String?) {
        guard let url: String else { return nil }
        self.init(string: url)
    }

    static func /(_ left: URL, _ right: String) -> URL { left.appendingPathComponent(right) }

}

public extension Optional where Wrapped == URL {

    static func /(_ left: URL?, _ right: String) -> URL? { left?.appendingPathComponent(right) }

}
