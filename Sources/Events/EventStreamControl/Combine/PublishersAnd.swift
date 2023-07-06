//
//  PublishersAnd.swift
//  Bumblebee
//
//  Created by sugarbaron on 07.11.2022.
//

import Combine

public extension Array where Element == AnyPublisher<Void, Error> {
    
    var joinedByAnd: Publishers.And { .init(self) }
    
}

public extension Publishers {
    
    /// unites several single-event publishers.
    /// publishes single event when all events of united publishers are happened.
    /// any failure in united publishers cause a failure of this publisher
    final class And : Publisher {
        
        public typealias Output = Void
        public typealias Failure = Error
    
        private var eventSources: [(publisher: AnyPublisher<Void, Error>, happened: Bool)]
        private var publisher: AnyPublisher<Void, Error>
        private var subscriptions: [AnyCancellable]
    
        public init(_ publishers: [AnyPublisher<Void, Error>]) {
            self.eventSources = publishers.map { ($0, false) }
            self.publisher = Empty(Void.self, Error.self).anyPublisher
            self.subscriptions = [ ]
            
            self.publisher = DeferredFuture { [weak self] promise in self?.watchEvents(promise) }.anyPublisher
        }
    
        public func receive<S>(subscriber: S) where S : Subscriber, S.Input == Void, S.Failure == Error {
            publisher.receive(subscriber: subscriber)
        }
    
    }
    
}

private extension Publishers.And {
    
    private func watchEvents(_ promise: @escaping (Result<Void, Error>) -> Void) {
        for i: Int in eventSources.indices {
            let publisher: AnyPublisher<Void, Error> = eventSources[i].publisher
            publisher.subscribe { [weak self] in self?.eventHappened(i, promise) }
                     onFailure: { promise(.failure($0)) }
                     .store { subscriptions += $0 }
        }
    }
    
    private func eventHappened(_ index: Int, _ promise: @escaping (Result<Void, Error>) -> Void) {
        eventSources[index].happened = true
        guard eventSources.allSatisfy({ $0.happened }) else { return }
        promise(.success(()))
    }

}
