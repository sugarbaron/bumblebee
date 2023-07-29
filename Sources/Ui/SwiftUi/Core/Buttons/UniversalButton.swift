//
//  UniversalButton.swift
//  bumblebee
//
//  Created by sugarbaron on 26.03.2023.
//

import SwiftUI

public extension View {
    
    func button(effect: Tap.Effect = .scale(),
                action: @escaping (Tap.Confirmation) -> Void,
                onTouch: @escaping () -> Void = {  }) -> some View {
        modifier(ResponsiveTap(effect, onTouch, action))
    }
    
    func button(effect: Tap.Effect = .scale(),
                action: @escaping () -> Void,
                onTouch: @escaping () -> Void = {  }) -> some View {
        modifier(ResponsiveTap(effect, onTouch, { if $0 == .confirmed { action() } }))
    }
    
}

public struct ResponsiveTap : ViewModifier {
    
    private let effect: Tap.Effect
    private let onTap: () -> Void
    private let onRelease: (Tap.Confirmation) -> Void
    private let tappedBorder: Border
    private let tappedScale: CGFloat
    
    @State private var released: Bool
    
    public init(_ effect: Tap.Effect,
                _ onTap: @escaping () -> Void,
                _ onRelease: @escaping (Tap.Confirmation) -> Void) {
        self.effect = effect
        self.onTap = onTap
        self.onRelease = onRelease
        if case .border(let color, let line, let corners) = effect {
            self.tappedBorder = Border(color: color, line: line, corners: corners)
        } else {
            self.tappedBorder = .noBorder
        }
        if case .scale(let scale) = effect {
            self.tappedScale = scale
        } else {
            self.tappedScale = 1
        }
        self.released = true
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(tapBorder)
            .scaleEffect(scale)
            .onTap {
                released = false
                onTap()
            } onRelease: {
                animate(.easeOut(duration: 0.1)) { released = true }
                onRelease($0)
            }
    }
    
    private var scale: CGFloat { (scaleEffect && tapped) ? tappedScale : 1 }
    
    @ViewBuilder
    private var tapBorder: some View {
        if (borderEffect && tapped) {
            Color.clear
                .border(tappedBorder)
                .blur(radius: 4)
                .border(.clear, line: 0, corners: corners)
        } else {
            Color.clear
        }
    }
    
    private var tapped: Bool { released == false }
    
    private var corners: CGFloat { borderEffect ? tappedBorder.corners : 0 }
    
    private var borderEffect: Bool { if case .border = effect { return true } else { return false } }
    
    private var scaleEffect: Bool { if case .scale = effect { return true } else { return false } }
    
}

public extension Tap {
    
    enum Effect {
        case scale(_ factor: CGFloat = 0.96)
        case border(color: Rgb = UIColor.black.rgb, line: CGFloat = 4, corners: CGFloat)
    }
    
}
