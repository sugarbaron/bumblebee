//
//  ThreadSafe.swift
//  Bumblebee
//
//  Created by sugarbaron on 15.12.2022.
//

import Foundation

public class ThreadSafe<T> {
    
    private var original: T
    private let mutex: NSRecursiveLock
    
    public init(_ original: T) {
        self.original = original
        self.mutex = NSRecursiveLock()
    }
    
    public static func <~(_ safe: ThreadSafe<T>, _ update: T) { safe.write(update) }
    
    public var it: T { mutex.lock(); let it: T = original; mutex.unlock(); return it }
    
    private func write(_ update: T) { mutex.lock(); original = update; mutex.unlock() }
    
}

public extension Optional {
    
    static func <~<T>(_ safe: Optional<ThreadSafe<T>>, _ update: T) where Wrapped == ThreadSafe<T> {
        unwrap(safe) { $0 <~ update }
    }
    
}

public extension Bool {
    
    var safe: ThreadSafe<Bool> { .init(self) }
    
}

public extension Optional {
    
    var safe: ThreadSafe<Wrapped?> { .init(self) }
    
}
