//
//  Semaphore.swift
//  Bumblebee
//
//  Created by sugarbaron on 27.10.2022.
//

import Foundation

public final class Semaphore {
    
    private let original: DispatchSemaphore
    
    public init(_ counter: Int = 0) { self.original = DispatchSemaphore(value: counter) }
    
    public func wait() { original.wait() }
    
    public func wait(timeout: TimeInterval) -> DispatchTimeoutResult {
        original.wait(timeout: DispatchTime.now() + .seconds(timeout.int))
    }
    
    public func wait(eventsNumber number: Int) { original.wait(eventsNumber: number) }
    
    public func signal() { original.signal() }
    
}

public extension DispatchSemaphore {

    func wait(eventsNumber number: Int) { (0..<number).forEach { _ in wait() } }

}
