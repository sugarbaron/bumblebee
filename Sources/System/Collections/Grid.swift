//
//  Grid.swift
//  Bumblebee
//

import Foundation

public class Grid<T> {
    
    private(set) var elements: [[T]]
    
    public init(_ elements: [[T]]) { self.elements = elements }
    
    convenience init() { self.init(.init()) }
    
    public var rows: Int { elements.count }
    
    public var elementsInLastRow: [T] { elements.last ?? .init() }
    
    public func elements(inRow rowIndex: Int) -> [T] {
        guard rowIndex.isOne(of: elements.indices) else { return .init() }
        return elements[rowIndex]
    }
    
    public func appendToLastRow(_ element: T) {
        var last: [T] = elements.last ?? .init()
        last.append(element)
        if elements.isNotEmpty { elements.removeLast() }
        elements.append(last)
    }
    
    public func appendRow(_ rowElements: [T]) { elements.append(rowElements) }
    
    public var last: T? { elements.last?.last }
    
}
