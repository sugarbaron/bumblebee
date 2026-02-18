//
//  ConcurrentLocked.swift
//  Bumblebee
//
//  Created by sugarbaron on 12.05.2025.
//

import Foundation

public final class Concurrent { }

public extension Concurrent {
    
    final class Locked<T> {
        
        private var original: T
        
        public init(_ original: T) {
            self.original = original
        }
        
        public func access(safe mutex: NSRecursiveLock) -> T {
            mutex.lock()
            let result: T = original
            mutex.unlock()
            return result
        }
        
        public func access(safe mutex: NSRecursiveLock, set new: T) {
            mutex.lock()
            original = new
            mutex.unlock()
        }
        
    }
    
}

