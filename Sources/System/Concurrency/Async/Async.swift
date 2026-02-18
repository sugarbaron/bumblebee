//
//  Async.swift
//  Bumblebee
//
//  Created by sugarbaron on 19.05.2023.
//

import Foundation

/// namespace class
public final class Async { }

@inlinable public func concurrent<T>(
    function: String = #function, _ callback: (CheckedContinuation<T, Error>) -> Void
) async throws -> T {
    try await withCheckedThrowingContinuation(function: function, callback)
}

@discardableResult
public func inBackground<T:Sendable>(
    priority: TaskPriority? = nil,
    _ coroutine: @Sendable @escaping () async throws -> T
) -> Async.Task<T, Error> {
    Async.Task.detached(priority: priority) { try await coroutine() }
}

public func ensureMain(_ action: @Sendable @escaping () -> Void) {
    if Thread.isMain {
        action()
    } else {
        onMain(action)
    }
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
    let nanoseconds: Double = duration * 1e9
    let safeDelay: UInt64 = switch cases {
    case _ where nanoseconds < Double(UInt64.min) + 1: UInt64.min
    case _ where nanoseconds > Double(UInt64.max) - 1: UInt64.max
    default: UInt64(nanoseconds)
    }
    do    { try await Task.sleep(nanoseconds: safeDelay) }
    catch { log(error: "[Async] sleep interrupted: \(error)") }
}

public extension Async {
    
    typealias Task = _Concurrency.Task
    
}

public extension Async.Task {
    
    func execute() async throws -> Success { try await value }
    
}

/// syntactic sugar for writing:
/// `await until([updateComplete, operationComplete])`
/// instead of:
/// let _: [Void?] = await [updateComplete, operationComplete]
public func until(_ events: [Void?]) { }
