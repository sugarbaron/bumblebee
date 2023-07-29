//
//  ExponentialBackoff.swift
//  Bumblebee
//
// Created by sugarbaron on 23.08.2022.
//

import Foundation

public final class ExponentialBackoff {

    private let queue: OperationQueue
    private let triesTotal: Int
    private var triesSpent: Int
    private let delay: TimeInterval
    private var action: () -> Void
    private var previousTryTime: Date?

    public init(tries times: Int, delay: TimeInterval = 1) {
        self.queue = .newSerial()
        self.triesTotal = times
        self.triesSpent = 0
        self.delay = delay
        self.action = { }
        self.previousTryTime = nil
    }

    public func execute(action: @escaping () -> Void) {
        self.action = action
        tryExecute()
    }

    /// returns nil if all tries are already used
    public func retry() -> Void? { tryExecute() }

    private func tryExecute() -> Void? {
        guard triesSpent < triesTotal else { return nil }
        let power: Double = (triesSpent - 1).double
        let currentDelay: TimeInterval = (triesSpent > 0) ? delay * pow(2.double, power) : 0
        let fireTime: Date = unwrap(previousTryTime) { $0.addingTimeInterval(currentDelay) } ?? .now
        self.previousTryTime = fireTime
        self.triesSpent += 1
        queue.execute { [weak self] in
            Thread.sleep(until: fireTime)
            self?.action()
        }
        return ()
    }

}
