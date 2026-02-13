//
//  IndexPathAdvanced.swift
//
//
//  Created by sugarbaron on 15.01.2024.
//

import Foundation

public extension IndexPath {
    
    init(_ item: Int, _ section: Int) { self.init(item: item, section: section) }
    
    static var zero: IndexPath { .init(0, 0) }
    
}
