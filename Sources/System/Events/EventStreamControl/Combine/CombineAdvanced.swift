//
//  CombineAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 30.09.2022.
//

import Combine

public extension Combine.Publishers {
    
    static func reborn<T, F:Error>(_ constructPublisher: @escaping () -> AnyPublisher<T, F>?,
                                     catch react: @escaping (F) -> Void = { _ in })
    -> some Publisher<T, Never> {
        nilToEmpty(constructPublisher()).skipFailure(constructPublisher, catch: react)
    }
    
    static func nilToEmpty<T, F:Error>(_ publisher: Optional<some Publisher<T, F>>) -> AnyPublisher<T, F> {
        unwrap(publisher) { $0.anyPublisher } ?? Empty(T.self, F.self).anyPublisher
    }
    
}

public extension Combine.Empty {
    
    init(_ output: Output.Type, _ failure: Failure.Type) { self.init(outputType: output, failureType: failure) }
    
    static func end() -> AnyPublisher<Output, Failure> {
        Empty(outputType: Output.self, failureType: Failure.self).anyPublisher
    }
    
}

public extension AnyCancellable {
    
    func store(_ store: (AnyCancellable) -> Void) { store(self) }
    
}
