//
//  UuidAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 22.02.2023.
//

import Foundation

public extension UUID {
    
    var int: Int {
        let bytes: Bytes = uuid
        return (bytes.15.int << (15 * 8))
             | (bytes.14.int << (14 * 8))
             | (bytes.13.int << (13 * 8))
             | (bytes.12.int << (12 * 8))
             | (bytes.11.int << (11 * 8))
             | (bytes.10.int << (10 * 8))
             | (bytes.9.int << (9 * 8))
             | (bytes.8.int << (8 * 8))
             | (bytes.7.int << (7 * 8))
             | (bytes.6.int << (6 * 8))
             | (bytes.5.int << (5 * 8))
             | (bytes.4.int << (4 * 8))
             | (bytes.3.int << (3 * 8))
             | (bytes.2.int << (2 * 8))
             | (bytes.1.int << 8)
             | (bytes.0.int)
    }
    
    private typealias Bytes = (UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8,
                               UInt8)
    
}
