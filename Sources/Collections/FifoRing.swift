//
//  FifoRing.swift
//  Bumblebee
//
//  Created by sugarbaron on 12.01.2023.
//

import Foundation

public final class FifoRing<Element> {
    
    private var elements: [Element?]
    private var readIndex: Int
    private var writeIndex: Int
    private let mutex: NSRecursiveLock
    
    init(size: Int) {
        self.elements = Array(repeating: nil, count: size)
        self.readIndex = 0
        self.writeIndex = 0
        self.mutex = NSRecursiveLock()
    }
    
}

// MARK: interface
public extension FifoRing {
    
    func write(_ element: Element) {
        mutex.lock(); defer { mutex.unlock() }
        elements[writeIndex] = element
        writeIndex = increment(writeIndex)
        if writeIndex == readIndex { readIndex = increment(readIndex) }
    }
    
    func read() -> Element? {
        mutex.lock(); defer { mutex.unlock() }
        if isEmpty { return nil }
        let element: Element? = elements[readIndex]
        elements[readIndex] = nil
        readIndex = increment(readIndex)
        return element
    }
    
    var isNotEmpty: Bool { isEmpty == false }
    
    var isEmpty: Bool { readIndex == writeIndex }
    
    private func increment(_ index: Int) -> Int { ((index + 1) < elements.count) ? (index + 1) : 0 }
    
}
