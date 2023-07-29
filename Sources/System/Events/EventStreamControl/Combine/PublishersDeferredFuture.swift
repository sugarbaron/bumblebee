//
//  PublishersDeferredFuture.swift
//  Bumblebee
//
//  Created by sugarbaron on 08.11.2022.
//

import Combine

public extension Publishers {
    
    final class DeferredFuture<T, F:Error> : Publisher {
    
        public typealias Output = T
        public typealias Failure = F
    
        private var deferred: AnyPublisher<T, F>
    
        public init(_ action: @escaping (@escaping (Result<T, F>) -> Void) -> Void) {
            self.deferred = DeferredOnce { Future(action) }.anyPublisher
        }
        
        public func receive<S>(subscriber: S) where S : Combine.Subscriber, S.Input == T, S.Failure == F {
            deferred.receive(subscriber: subscriber)
        }
        
    }
    
}
