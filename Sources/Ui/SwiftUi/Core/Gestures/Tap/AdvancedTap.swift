//
//  AdvancedTap.swift
//  bumblebee
//
//  Created by sugarbaron on 11.02.2023.
//

import SwiftUI

internal extension View {
    
    func advancedTap(_ onTouch: @escaping () -> Void, onRelease: @escaping (Tap.Confirmation) -> Void) -> some View {
        modifier(AdvancedTap(onTouch, onRelease))
    }
    
}

private struct AdvancedTap : ViewModifier {
    
    private let onTouch: () -> Void
    private let onRelease: (Tap.Confirmation) -> Void
    @State private var begun: Bool
    
    init(_ onTouch: @escaping () -> Void, _ onRelease: @escaping (Tap.Confirmation) -> Void) {
        self.onTouch = onTouch
        self.onRelease = onRelease
        self.begun = false
    }
    
    func body(content: Content) -> some View { content.gesture(advancedTap) }
    
    private var advancedTap: some Gesture {
        DragGesture(minimumDistance: 0.0)
            .onChanged { gesture in if begun { return }; begun = true; onTouch() }
            .onEnded   { gesture in
                let confirmation: Tap.Confirmation = (gesture.translation.distance > 75) ? .rejected : .confirmed
                onRelease(confirmation)
                begun = false
            }
    }
    
}

public extension Tap {
    
    enum Confirmation { case confirmed; case rejected }
    
}

private extension CGSize {
    
    var distance: CGFloat { sqrt(pow(width, 2) + pow(height, 2)) }
    
}
