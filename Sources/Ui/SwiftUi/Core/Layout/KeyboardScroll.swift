//
//  KeyboardScroll.swift
//  
//
//  Created by sugarbaron on 17.07.2023.
//

import SwiftUI

public extension View {
    
    func scroll(when keyboard: Bool) -> some View { modifier(Keyboard.Modifier(keyboard)) }
    
}

private extension Keyboard {

    struct Modifier : ViewModifier {

        private var keyboard: Bool

        init(_ keyboard: Bool) { self.keyboard = keyboard }

        func body(content: Content) -> some View {
            ScrollView(unlocked, showsIndicators: true) { content }.onTap { collapseKeyboard() }
        }
        
        private var unlocked: Axis.Set { keyboard ? .vertical : [ ] }
        

    }

}
