//
//  Limiter.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.03.2021.
//


import Foundation

public final class RateLimiter {

    private let seconds: TimeInterval
    
    private var lastExecution: Date? = nil
    
    public init(seconds: TimeInterval) { self.seconds = seconds }
    
    public func execute(_ action: () -> Void) {
        if isTooEarly { return }
        lastExecution = Date.now
        action()
    }
    
    private var isTooEarly: Bool {
        if let lastAttempt = lastExecution, Date.now.since(lastAttempt) < seconds { return true }
        return false
    }
    
}
