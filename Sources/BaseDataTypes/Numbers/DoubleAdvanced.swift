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

}
