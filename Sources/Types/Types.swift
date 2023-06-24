//
//  Types.swift
//  Bumblebee
//
//  Created by sugarbaron on 20.04.2022.
//

public func convert<Source, Destination>(_ source: Source) throws -> Destination {
    if let destination: Destination = source as? Destination { return destination }
    throw Exception("[Classes] unable to convert:[\(name(of: Source.self)) \(name(of: Destination.self))]")
}

public func name<Type>(of type: Type.Type) -> String { String(describing: type) }
