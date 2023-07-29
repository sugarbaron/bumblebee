//
//  PublisherAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 08.11.2022.
//

import Foundation
import Combine

public extension Combine.Publisher {
    
    /// same thing as sink, for those who want to get rid of plumbing terms in programming
    func subscribe(onEvent:   @escaping (Output) -> Void,
                   onFailure: @escaping (Failure) -> Void = { _ in },
                   onFinish:  @escaping () -> Void = { }) -> AnyCancellable {
        receive(onEvent, onFailure, onFinish)
    }
    
    /// same thing as sink, for those who want to get rid of plumbing terms in programming
    func subscribe(onEvent:   @escaping () -> Void,
                   onFailure: @escaping (Failure) -> Void = { _ in },
                   onFinish:  @escaping () -> Void = { }) -> AnyCancellable {
        receive({ _ in onEvent() }, onFailure, onFinish)
    }
    
    func consumeFailure(_ react: @escaping (Failure) -> Void = { _ in }) -> some Publisher<Output, Never> {
        self.catch { react($0); return Empty(Output.self, Never.self) }
    }
    
    func skipFailure(_ recoverPublisher: @escaping () -> AnyPublisher<Output, Failure>?,
                     catch onFailure: @escaping (Failure) -> Void = { _ in })
    -> some Publisher<Output, Never> {
        self.catch { onFailure($0); return recover(with: recoverPublisher, onFailure) }
            .catch { _ in Empty(outputType: Output.self, failureType: Never.self) }
        // above catch is just to convert Failure to Never. actually it never happens
    }
    
    func mapError<F:Error>(_ transform: @escaping () -> F) -> some Publisher<Output, F> {
        mapError { _ in transform() }
    }
    
    func forEach(_ process: @escaping (Output) -> Void) -> some Publisher<Output, Failure> {
        handleEvents(receiveOutput: process)
    }
    
    func forEach(_ process: @escaping () -> Void) -> some Publisher<Output, Failure> {
        handleEvents(receiveOutput: { _ in process() })
    }
    
    func onEvent(_ process: @escaping (Output) -> Void) -> some Publisher<Output, Failure> {
        handleEvents(receiveOutput: process)
    }
    
    func onEvent(_ process: @escaping () -> Void) -> some Publisher<Output, Failure> {
        handleEvents(receiveOutput: { _ in process() })
    }
    
    func onFailure(_ react: @escaping (Failure) -> Void) -> some Publisher<Output, Failure> { onFailure(react: react) }
    
    func onFailure(react: @escaping () -> Void) -> some Publisher<Output, Failure> {
        handleEvents(receiveCompletion: { if case .failure = $0 { react() } })
    }
    
    func onFinish(_ react: @escaping () -> Void) -> some Publisher<Output, Failure> {
        handleEvents(receiveCompletion: { if case .finished = $0 { react() } })
    }
    
    func map<T>(_ transform: @escaping () -> T) -> some Publisher<T, Failure> { map { _ in transform() } }
    
    func compactMap<T>(_ transform: @escaping () -> T) -> some Publisher<T, Failure> { compactMap { _ in transform() } }
    
    var anyPublisher: AnyPublisher<Output, Failure> { eraseToAnyPublisher() }
    
    func receiveOnMain() -> some Publisher<Output, Failure> { receive(on: DispatchQueue.main)  }
    
    func receive(on queue: OperationQueue) -> some Publisher<Output, Failure> {
        let scheduler: some Scheduler = queue
        return receive(on: scheduler)
    }
    
    func debounce(for interval: TimeInterval, _ queue: OperationQueue) -> some Publisher<Output, Failure> {
        let scheduler: some Scheduler = queue
        return debounce(for: .seconds(interval), scheduler: scheduler)
    }
    
}

private extension Combine.Publisher {
    
    func receive(_ onEvent:   @escaping (Output) -> Void,
                 _ onFailure: @escaping (Failure) -> Void = { _ in },
                 _ onFinish:  @escaping () -> Void = { }) -> AnyCancellable {
        let complete: (Combine.Subscribers.Completion<Failure>) -> Void = {
            switch $0 {
            case .failure(let error): onFailure(error)
            case .finished: onFinish()
            }
        }
        return sink(receiveCompletion: complete, receiveValue: onEvent)
    }
    
    // powerful brown magic
    func recover(with construct: @escaping () -> AnyPublisher<Output, Failure>?,
                 _ onFailure: @escaping (Failure) -> Void) -> AnyPublisher<Output, Failure> {
        run(construct).catch { onFailure($0); return recover(with: construct, onFailure) }.anyPublisher
    }
    
    func onFailure(react: @escaping (Failure) -> Void) -> some Publisher<Output, Failure> {
        handleEvents(receiveCompletion: { if case .failure(let failure) = $0 { react(failure) } })
    }
    
}

private func run<Output, Failure>(_ constructRecover: @escaping () -> AnyPublisher<Output, Failure>?)
-> some Publisher<Output, Failure> {
    constructRecover() ?? Empty(Output.self, Failure.self).anyPublisher
}
