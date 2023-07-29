//
//  ModifiersAdvanced.swift
//  bumblebee
//
//  Created by sugarbaron on 31.01.2023.
//

import SwiftUI
import Combine

public extension View {
    
    func over(host: some View) -> some View { host.overlay(self) }
    
    @available(iOS 14.0, *)
    func over(fullscreenHost host: some View) -> some View { host.ignoresSafeArea().overlay(self) }
    
    func foreground(_ color: Color) -> some View { foregroundColor(color) }
    
    @available(iOS 15.0, *)
    func background(_ color: Color) -> some View { background(color, ignoresSafeAreaEdges: .all) }
    
    func subscribe<P:Publisher>(to publisher: P, _ reaction: @escaping (P.Output) -> Void)
    -> some View where P.Failure == Never {
        onReceive(publisher, perform: reaction)
    }
    
    func alignment(_ alignment: Alignment) -> some View { frame(width: nil, height: nil, alignment: alignment) }
    
    func border(_ parameters: Border) -> some View {
        border(parameters.color.ui, line: parameters.line, corners: parameters.corners)
    }
    
    func border(_ color: Color, line: CGFloat = 1.0, corners: CGFloat = 0.0) -> some View {
        let rounded: RoundedRectangle = .init(cornerRadius: corners)
        return clipShape(rounded).overlay(rounded.strokeBorder(color, lineWidth: line))
    }
    
    @ViewBuilder func `if`<V:View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> V) -> some View {
        if condition() { transform(self) } else { self }
    }
    
    @ViewBuilder func `if`<T, V:View>(`let` optional: @autoclosure () -> T?, transform: (Self, T) -> V) -> some View {
        if let unwrapped: T = optional() { transform(self, unwrapped) } else { self }
    }
    
    func dbg(_ record: String) -> some View { Bumblebee.log(record); return self }
    
    func execute(_ action: () -> Void) -> some View { action(); return self }
    
    @available(iOS 14.0, *)
    func onChange<T:Equatable>(of target: T, _ react: @escaping () -> Void) -> some View {
        onChange(of: target) { _ in react() }
    }
    
    func priority(_ level: Double) -> some View { layoutPriority(level) }
    
    func keyboard(_ type: UIKeyboardType) -> some View { keyboardType(type) }
    
    func ignore(safeArea edges: Edge.Set, _ regions: SafeAreaRegions = .all) -> some View {
        ignoresSafeArea(regions, edges: edges)
    }
    
    func corners(_ radius: CGFloat) -> some View { cornerRadius(radius) }
    
}

public extension Text {
    
    func weight(_ weight: Font.Weight?) -> Text { fontWeight(weight) }
    
}

public func collapseKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

public extension View { typealias Size = ViewSize }

public final class ViewSize { public enum Dimension { case w; case h } }
