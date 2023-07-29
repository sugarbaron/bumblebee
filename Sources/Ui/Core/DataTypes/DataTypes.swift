//
//  DataTypes.swift
//  bumblebee
//
//  Created by sugarbaron on 25.03.2023.
//

import SwiftUI

public final class Border {
    
    public let color: Rgb
    public let line: CGFloat
    public let corners: CGFloat
    
    public init(color: Rgb, line: CGFloat, corners: CGFloat) {
        self.color = color
        self.line = line
        self.corners = corners
    }
    
    public static let noBorder: Border = .init(color: UIColor.clear.rgb, line: 0, corners: 0)
    
}
