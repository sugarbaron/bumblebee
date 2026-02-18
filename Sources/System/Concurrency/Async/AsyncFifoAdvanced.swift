//
//  AsyncFifoAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 26.11.2024.
//

public extension Async.Fifo {
    
    func enqueued(
        _ coroutine: @Sendable @escaping () async throws -> Void,
        catch: @escaping (Error) -> Void = { log(error: "[Async.Fifo][enqueued] \($0)") }
    ) async {
        let _: Void? = try? await concurrent { [weak self] execution in
            self?.enqueue {
                try await coroutine()
                execution.resume(returning: ())
            } catch: {
                `catch`($0)
                execution.resume(returning: ())
            }
        }
    }
    
}
