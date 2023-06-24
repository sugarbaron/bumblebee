//
//  Async.swift
//  Bumblebee
//
//  Created by sugarbaron on 19.05.2023.
//

import Foundation

/// namespace class
public final class Async { }

@inlinable public func concurrent<T>(function: String = #function, _ callback: (CheckedContinuation<T, Error>) -> Void)
async throws -> T {
    try await withCheckedThrowingContinuation(function: function, callback)
}

@discardableResult
public func inBackground<T:Sendable>(_ coroutine: @Sendable @escaping () async throws -> T) -> Async.Task<T, Error> {
    Async.Task.detached(priority: .low) {
        if Thread.isMain { log(warning: "[Async] attention!!! background computations started on main thread!!!") }
        let result: T = try await coroutine()
        if Thread.isMain { log(warning: "[Async] attention!!! background computations finished on main thread!!!") }
        return result
    }
    // fixme: replace function body with following code when debug will be finished
    // Async.Task.detached(priority: priority, operation: coroutine)
}

@discardableResult
public func onMain<T:Sendable>(_ coroutine: @MainActor @Sendable @escaping () throws -> T) -> Async.Task<T, Error> {
    Async.Task.detached { try await MainActor.run { try coroutine() } }
}

@discardableResult
public func onMain<T:Sendable>(after delay: TimeInterval, _ coroutine: @MainActor @Sendable @escaping () throws -> T)
-> Async.Task<T, Error> {
    Async.Task.detached { await idle(delay); return try await MainActor.run { try coroutine() } }
}

public func idle(_ duration: TimeInterval) async {
    do    { try await Task.sleep(nanoseconds: UInt64(duration * 1e9)) }
    catch { log(error: "[Async] sleep interrupted: \(error)") }
}

public extension Async {
    
    typealias Task = _Concurrency.Task
    
}

public extension Async.Task {
    
    func execute() async throws -> Success { try await value }
    
}
