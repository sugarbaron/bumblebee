//
//  AsyncIsolated.swift
//  Bumblebee
//
//  Created by sugarbaron on 24.05.2023.
//

// MARK: constructor
public extension Async {
 
    actor Isolated {
        
        private let safe: AsyncSafe
        
        public init() { self.safe = AsyncSafe() }
        
    }
    
}

// MARK: interface
public extension Async.Isolated {
    
    /// attention!!! isolated section is not reentrant!
    /// calling `section` of same `Async.Isolated` inside `section` will cause deadlock
    func section(_ section: @Sendable @escaping () async throws -> Void,
                  catch: @escaping (Error) -> Void = { log(error: "[Async.Isolated] section throws: \($0)") })
    async {
        let targetId: Int = await self.safe.enqueue(section, `catch`)
        while let next: Running = await safe.runNext() {
            let completedId: Int = await next.execute()
            if completedId == targetId { return }
        }
    }
    
}

// MARK: safe state
private extension Async.Isolated {
    
    private final actor AsyncSafe {
        
        private var queue: [Scheduled]
        private var previousId: Int
        private var inProgress: Running?
        
        init() {
            self.queue = [ ]
            self.previousId = -1
            self.inProgress = nil
        }
        
        func enqueue(_ section: @Sendable @escaping () async throws -> Void, _ catch: @escaping (Error) -> Void)
        -> Int {
            let id: Int = nextId
            self.queue += (id, section, `catch`)
            return id
        }
        
        func runNext() -> Running? {
            if let inProgress: Running { return inProgress }
            guard let next: Scheduled = self.next else { return nil }
            let isolation: Execution = .init { try await next.section(); self.inProgress = nil }
            self.inProgress = Running(next.id, isolation, next.catch)
            return inProgress
        }
        
        private var next: Scheduled? { queue.isEmpty ? nil : queue.removeFirst() }
        
        private var nextId: Int {
            let id: Int = (previousId == Int.max) ? 0 : previousId + 1
            self.previousId = id
            return id
        }
        
        typealias Scheduled = (id: Int, section: () async throws -> Void, catch: (Error) -> Void)
        
    }
    
}

private extension Async.Isolated {
    
    final class Running {
        
        let id: Int
        let isolation: Execution
        let `catch`: (Error) -> Void
        
        init(_ id: Int, _ isolation: Execution, _ catch: @escaping (Error) -> Void) {
            self.id = id
            self.isolation = isolation
            self.catch = `catch`
        }
        
        func execute() async -> Int {
            do { try await isolation.execute() } catch { `catch`(error) }
            return id
        }
        
    }
    
    typealias Execution = Async.Task<Void, Error>
    
}
