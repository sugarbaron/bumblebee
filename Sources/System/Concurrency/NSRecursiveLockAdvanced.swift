//
//  NSRecursiveLockAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 12.05.2025.
//

import Foundation

public extension NSRecursiveLock {
    
    func safe<T>(access locked: Concurrent.Locked<T>) -> T {
        locked.access(safe: self)
    }
    
    func safe<T>(update locked: Concurrent.Locked<T>, _ new: T) {
        locked.access(safe: self, set: new)
    }
    
    @discardableResult
    func access<T>(_ execute: () -> T) -> T {
        lock()
        let result: T = execute()
        unlock()
        return result
    }
    
}

