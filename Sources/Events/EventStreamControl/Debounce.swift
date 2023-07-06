//
//  Debounce.swift
//  ios-b2field
//
//  Created by sugarbaron on 23.03.2021.
//

import Foundation

public final class Debounce {

    private let delay: TimeInterval
    private var background: OperationQueue = .newSerial()

    public init(delay: TimeInterval) { self.delay = delay }

    public func execute(action: @escaping () -> Void) {
        let delay = self.delay
        background.cancelAllOperations()
        background.execute { [weak self] cancelled in
            let waiting: Waiting? = self?.wait(for: delay, cancelled)
            guard waiting == .itIsTime else { return }
            action()
        }
    }

    private func wait(for duration: TimeInterval, _ enough: () -> Bool) -> Waiting {
        let timeToAwake: Date = .now + duration
        while timeToAwake - .now > 0 {
            let unit: TimeInterval = duration < 0.2 ? duration : 0.2
            Thread.sleep(forTimeInterval: unit)
            if enough() { return .aborted }
        }
        return .itIsTime
    }

    public var isNotEmpty: Bool { isEmpty == false }

    public var isEmpty: Bool { background.operations.isEmpty }

    public func reset() { background.cancelAllOperations() }

    private enum Waiting { case itIsTime; case aborted }

}
