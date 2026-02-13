//
//  ConcurrentMap.swift
//  Bumblebee
//
//  Created by sugarbaron on 12.10.2020.
//

import Foundation

public final class ConcurrentMap<K : Hashable, V> {
    
    private let mutex: NSRecursiveLock
    private var map: [K : V]
    
    public init() {
        self.mutex = NSRecursiveLock()
        self.map = [ : ]
    }
    
    public subscript(key: K) -> V? {
        get {
            var value: V? = nil
            mutex.lock()
            value = map[key]
            mutex.unlock()
            return value
        }
        
        set(newValue) {
            mutex.lock()
            map[key] = newValue
            mutex.unlock()
        }
    }
    
    public func access(_ action: ([K : V]) -> Void) {
        mutex.lock()
        action(map)
        mutex.unlock()
    }
    
    public var isEmpty: Bool {
        mutex.lock()
        defer { mutex.unlock() }
        return map.isEmpty
    }
    
    public var isNotEmpty: Bool { isEmpty == false }
    
    public static func <~(_ safe: ConcurrentMap, _ update: [K : V]) { safe.write(update) }
    
    private func write(_ update: [K : V]) { mutex.lock(); map = update; mutex.unlock() }
    
}
