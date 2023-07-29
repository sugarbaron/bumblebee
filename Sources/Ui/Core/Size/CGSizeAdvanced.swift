//
//  CGSizeAdvanced.swift
//  bumblebee
//
//  Created by sugarbaron on 16.05.2023.
//

import SwiftUI

public extension CGSize {
    
    init(w: CGFloat, h: CGFloat) { self.init(width: w, height: h) }
    
    init(squared side: CGFloat) { self.init(width: side, height: side) }
    
    var w: CGFloat { width }
    
    var h: CGFloat { height }
    
}
