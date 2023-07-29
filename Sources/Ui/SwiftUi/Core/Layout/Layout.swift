//
//  Layout.swift
//  bumblebee
//
//  Created by sugarbaron on 07.02.2023.
//

import SwiftUI

public extension GeometryProxy {
    
    var w: CGFloat { size.width }
    
    var h: CGFloat { size.height }
    
}

public extension View {
    
    func positionAt(center available: GeometryProxy) -> some View {
        position(x: available.frame(in: .local).midX, y: available.frame(in: .local).midY)
    }
    
}

public extension Spacer {
    
    init(min length: CGFloat) { self.init(minLength: length) }
    
}
