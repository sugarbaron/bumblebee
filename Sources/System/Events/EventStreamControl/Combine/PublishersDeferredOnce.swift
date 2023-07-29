//
//  PublishersDeferredOnce.swift
//  Bumblebee
//
//  Created by sugarbaron on 08.11.2022.
//

import Combine

public extension Publishers {
    
    final class DeferredOnce<T, F:Error> : Publisher {
        
        public typealias Output = T
        public typealias Failure = F
    
        private var wrapped: AnyPublisher<T, F>?
        private var deferred: AnyPublisher<T, F>
        
        public init(_ constructPublisher: @escaping () -> some Publisher<T, F>) {
            self.wrapped = nil
            self.deferred = Empty(T.self, F.self).anyPublisher
            
            self.deferred = Deferred { [weak self] in
                let publisher: AnyPublisher<T, F> = unwrap(self?.wrapped) { $0 } ?? constructPublisher().anyPublisher
                if self?.wrapped == nil { self?.wrapped = publisher }
                return publisher
            }.anyPublisher
        }
        
        public func receive<S>(subscriber: S) where S: Subscriber, S.Input == T, S.Failure == F {
            deferred.receive(subscriber: subscriber)
        }
        
    }
    
}
