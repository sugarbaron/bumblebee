//
//  Tap.swift
//  bumblebee
//
//  Created by sugarbaron on 12.02.2023.
//

import SwiftUI

/// namespace class
public final class Tap { }

public extension View {
    
    func onTap(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        tapable().onTapGesture(count: count, perform: action)
    }
    
    func onTap(_ onTouch: @escaping () -> Void, onRelease: @escaping (Tap.Confirmation) -> Void) -> some View {
        tapable().advancedTap(onTouch, onRelease: onRelease)
    }
    
    func tapable() -> some View { contentShape(Rectangle()) }
    
    @available(iOS 15.0, *)
    func tapArea(squared: CGFloat) -> some View { tapArea(width: squared, height: squared) }
    
    @available(iOS 15.0, *)
    func tapArea(width: CGFloat, height: CGFloat) -> some View {
        Rectangle()
            .foreground(.clear)
            .frame(maxWidth: width, maxHeight: height)
            .overlay { self }
    }
    
}
