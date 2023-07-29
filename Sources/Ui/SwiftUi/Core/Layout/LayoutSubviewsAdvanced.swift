//
//  LayoutSubviewsAdvanced.swift
//  treasury
//
//  Created by sugarbaron on 11.02.2023.
//

import SwiftUI

@available(iOS 16.0, *)
public extension LayoutSubviews {
    
    var spacing: Layout.Spacing {
        if count < 2 { return (0.0, 0.0) }
        let item0: Element = self[0]
        let item1: Element = self[1]
        let x: CGFloat = item0.spacing.distance(to: item1.spacing, along: .horizontal)
        let y: CGFloat = item0.spacing.distance(to: item1.spacing, along: .vertical)
        return (x, y)
    }
    
    var lastIndex: Int? { (count > 0) ? count - 1 : nil }
    
    subscript(safe index: Int?) -> Element? { unwrap(index) { $0.isOne(of: indices) ? self[$0] : nil } }
    
}

@available(iOS 16.0, *)
public extension ProposedViewSize {
    
    static func size(w: CGFloat, h: CGFloat) -> ProposedViewSize { .init(width: w, height: h) }
    
}

@available(iOS 16.0, *)
public extension Layout { typealias Spacing = (w: CGFloat, h: CGFloat) }
