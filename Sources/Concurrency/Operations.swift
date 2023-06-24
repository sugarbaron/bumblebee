//
//  Operations.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

import Foundation

public extension OperationQueue {

    static func newSerial() -> OperationQueue {
        let serial: OperationQueue = OperationQueue()
        serial.maxConcurrentOperationCount = 1
        return serial
    }

    static func newPool(withSize poolSize: Int) -> OperationQueue {
        let pool: OperationQueue = .init()
        pool.maxConcurrentOperationCount = poolSize
        return pool
    }

    func execute(afterDelay delay: TimeInterval, _ execution: @escaping () -> Void) {
        execute { Thread.sleep(delay); execution() }
    }
    
    var isBusy: Bool { isEmpty == false }
    
    var isEmpty: Bool { operations.isEmpty }

}

// MARK: cancellable
public extension OperationQueue {

    func execute(_ action: @escaping () -> Void) {
        let operation: AutoCancellableOperation = .init(action)
        addOperation(operation)
    }

    func execute(_ action: @escaping (() -> Bool) -> Void) {
        let operation: ManualCancellableOperation = .init(action)
        addOperation(operation)
    }
    
}

private class AutoCancellableOperation : Operation {

    private let action: () -> Void

    init(_ action: @escaping () -> Void) {
        self.action = action
        super.init()
    }

    override func main() {
        if isCancelled { return }
        action()
    }

}

private class ManualCancellableOperation : Operation {

    private var action: ((() -> Bool) -> Void)? = nil

    convenience init(_ action: @escaping (() -> Bool) -> Void) {
        self.init()
        self.action = action
    }

    override func main() {
        guard !(isCancelled) else { return }
        action?({ [weak self] in self?.isCancelled ?? true })
    }

}
