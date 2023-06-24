//
//  Di.swift
//  Bumblebee
//
//  Created by sugarbaron on 28.07.2022.
//

import Foundation
import Swinject

// MARK: constructor
public class Di {
    
    private let assembler: Assembler
    private let di: Resolver
    private let mutex: NSRecursiveLock
    
    public init(_ assemblages: [Assembly]) {
        self.assembler = Assembler(assemblages)
        self.di = assembler.resolver
        self.mutex = .init()
    }
    
}
    
// MARK: interface
public extension Di {
    
    // parameter is for ability to specify nullable type, for example:
    // guard let service: Service = Di.inject(Service?.self)
    // because if you try:
    // guard let service: Service = Di.inject()
    // generic parameter Type will be equal to Service, but not Optional<Service>
    func inject<T:Nullable>(_ type: T.Type) -> T {
        mutex.lock()
        let instance: T = di.inject(type)
        mutex.unlock()
        return instance
    }
    
    func inject<T:Nullable>(_ type: T.Type, for id: String) -> T {
        mutex.lock()
        let instance: T = di.inject(type, id: id)
        mutex.unlock()
        return instance
    }
    
    func inject<T:Nullable, A>(_ type: T.Type, _ argument: A) -> T {
        mutex.lock()
        let instance: T = di.inject(type, argument: argument)
        mutex.unlock()
        return instance
    }
    
    func inject<T:Nullable, A>(_ type: T.Type, for id: String, _ argument: A) -> T {
        mutex.lock()
        let instance: T = di.inject(type, id: id, argument: argument)
        mutex.unlock()
        return instance
    }

}

public extension Swinject.Container {

    @discardableResult
    func register<T:Nullable>(_ type: T.Type, _ construct: @escaping () -> T) -> ServiceEntry<T> {
        register(type) { _ in construct() }
    }
    
    func singleton<T:Nullable>(_ type: T.Type, _ construct: @escaping () -> T) {
        register(type) { _ in construct() }.inObjectScope(.container)
    }
    
    func singleton<T:Nullable>(_ type: T.Type, _ construct: @escaping () async -> T) {
        register(type) { _ in Di.async { $0.instance = await construct() } }.inObjectScope(.container)
    }
    
    func singleton<T:Nullable>(_ type: T.Type, _ construct: @escaping (Swinject.Resolver) -> T) {
        register(type) { construct($0) }.inObjectScope(.container)
    }
    
    func singleton<T:Nullable>(_ type: T.Type, _ construct: @escaping (Swinject.Resolver) async -> T) {
        register(type) { di in Di.async { $0.instance = await construct(di) } }.inObjectScope(.container)
    }

}

public extension Swinject.Resolver {
    
    func inject<T:Nullable>(_ type: T.Type) -> T { resolve(type) ?? log(nil: "[Di] unable to resolve:[\(type)]") }
    
    func inject<T:Nullable>(_ type: T.Type, id: String) -> T {
        resolve(type, name: id) ?? log(nil: "[Di] unable to resolve:[\(type)] id:[\(id)]")
    }
    
    func inject<T:Nullable, A>(_ type: T.Type, argument: A) -> T {
        resolve(type, argument: argument) ?? log(nil: "[Di] unable to resolve:[\(type)] (a)")
    }
    
    func inject<T:Nullable, A>(_ type: T.Type, id: String, argument: A) -> T {
        resolve(type, name: id, argument: argument) ?? log(nil: "[Di] unable to resolve:[\(type)] id:[\(id)] (a)")
    }
    
}

// MARK: tools
private extension Di {
    
    static func async<T:Nullable>(_ construct: @escaping (Construction<T>) async -> Void) -> T {
        let construction: Construction<T> = .init()
        let complete: Semaphore = .init()
        inBackground { await construct(construction); complete.signal() }
        complete.wait()
        return construction.instance ?? nil
    }

    final class Construction<T> { var instance: T? = nil }
    
}
