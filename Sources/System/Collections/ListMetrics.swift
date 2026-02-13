//
//  ListMetrics.swift
//  Bumblebee
//
//  Created by sugarbaron on 23.12.2024.
//

import Foundation

// MARK: constructor
public final class ListMetrics {
    
    private let sizes: (sections: [Int], total: Int)
    
    private init<T>(_ matrix: [[T]]) {
        let sizes: [Int] = matrix.map { $0.count }
        let total: Int = sizes.reduce(into: Int()) { total, size in total += size }
        self.sizes = (sizes, total)
    }
    
    public convenience init<T>(plain list: [T]) {
        self.init([list])
    }
    
    public convenience init<T>(matrix: [[T]]) {
        self.init(matrix)
    }
    
}

// MARK: interface
public extension ListMetrics {
    
    var total: Int { sizes.total }
    
    var lastIndex: Int { sizes.total - 1 }
    
    func offset(for index: IndexPath) -> Int {
        let sectionOffset: Int = (0..<index.section).reduce(into: Int()) { sectionOffset, section in
            sectionOffset += sizes.sections[safe: section] ?? 0
        }
        return (sectionOffset + index.item).restrict(0..<sizes.total)
    }
    
}

// MARK: contributions
public extension Array {
    
    var metrics: ListMetrics { .init(plain: self) }
    
}
