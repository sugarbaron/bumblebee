//
//  PropertyWrappers.swift
//  bumblebee
//
//  Created by sugarbaron on 31.01.2023.
//

import SwiftUI

public extension ObservableObject {
    
    @available(iOS 14.0, *)
    var stateObject: StateObject<Self> { .init(wrappedValue: self) }
    
}

public extension State { init(wrapped: Value) { self.init(wrappedValue: wrapped) } }

public extension State { var wrapped: Value { wrappedValue } }

public extension Binding { var wrapped: Value { get { wrappedValue } set { wrappedValue = newValue } } }

public extension ObservedObject { var wrapped: ObjectType { wrappedValue } }

@available(iOS 14.0, *)
public extension StateObject { var wrapped: ObjectType { wrappedValue } }

public extension Binding {
    
    static func stub(_ wrapped: Value) -> Binding<Value> { Binding { wrapped } set: { _ in } }
    
    static func readonly(_ wrapped: Value) -> Binding<Value> { Binding { wrapped } set: { _ in } }
    
}
