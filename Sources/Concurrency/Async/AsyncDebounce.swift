//
//  AsyncDebounce.swift
//  Bumblebee
//
//  Created by sugarbaron on 05.06.2023.
//

import Foundation

// MARK: constructor
public extension Async {
    
    final class Debounce {
        
        private var action: () async throws -> Void
        private var `catch`: (Error) -> Void
        private let latency: TimeInterval
        private var fireTime: Date
        private let background: Fifo
        private let access: NSRecursiveLock
        
        public init(latency: TimeInterval) {
            self.action = { }
            self.catch = { _ in }
            self.latency = latency
            self.fireTime = Date(since1970: 0)
            self.background = Fifo()
            self.access = NSRecursiveLock()
        }
        
    }
    
}

// MARK: interface
public extension Async.Debounce {
    
    func schedule(_ action: @Sendable @escaping () async throws -> Void,
                  catch: @escaping (Error) -> Void = { log(error: "[Async.Debounce] action error: \($0)") }) {
        access.lock()
        self.action = action
        self.catch = `catch`
        self.fireTime = now + latency
        access.unlock()
        if background.isBusy { return }
        background.enqueue { [weak self] in await self?.debounce() }
    }
    
    private func debounce() async {
        while let tillFire: TimeInterval, tillFire > 0 { await idle(tillFire) }
        do    { try await action() }
        catch { `catch`(error) }
    }
    
    private var tillFire: TimeInterval? {
        access.lock()
        let tillFire: TimeInterval = fireTime - now
        access.unlock()
        return tillFire
    }
    
    private var now: Date { .init() }
    
}
