//
//  SizeMeter.swift
//  bumblebee
//
//  Created by sugarbaron on 13.03.2023.
//

import SwiftUI

public extension View {
    
    func measure(_ size: Binding<CGSize?>) -> some View { modifier(SizeMeter(size)) }
    
}

private struct SizeMeter : ViewModifier {
    
    @Binding private var size: CGSize?
    
    init(_ size: Binding<CGSize?>) { self._size = size }
    
    func body(content: Content) -> some View { content.background(Dimensions($size)) }
    
}

private struct Dimensions : View {
    
    @Binding private var size: CGSize?
    
    init(_ size: Binding<CGSize?>) { self._size = size }
    
    var body: some View { GeometryReader { available in
        Color.clear.onAppear { size = available.size }
    } }
    
}
