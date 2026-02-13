//
//  DoubleAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

import Foundation

public extension Double {

    func isSame(as another: Double) -> Bool { fabs(self - another) < Double.ulpOfOne }

    var int: Int { .init(self) }
    
    var cgFloat: CGFloat { .init(self) }

    func string(leadingZeroes: Int = 3, precision: Int = 6) -> String {
        .init(format: "%0\(leadingZeroes).\(precision)f", self)
    }
    
    func string(precision: Int) -> String { .init(format: "%.\(precision)f", self) }

}

public extension Optional where Wrapped == Double {
    
    static func +=(_ this: inout Double?, _ that: Double?) {
        guard let that: Double else { return }
        guard let it: Double = this else { this = that; return }
        this = it + that
    }
    
}
