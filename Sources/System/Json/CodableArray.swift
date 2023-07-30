//
//  CodableArray.swift
//  bumblebee
//
//  Created by sugarbaron on 15.07.2021.
//

import Foundation

public extension Json {
    
    func safeDeserialize<E:Decodable>(_ serialized: JsonBinary) throws -> [E] {
        let deserialized: DecodableArray<E> = try deserialize(serialized)
        return deserialized.content
    }
    
    func safeDeserialize<E:Decodable>(_ serialized: JsonString) throws -> [E] {
        let deserialized: DecodableArray<E> = try deserialize(serialized)
        return deserialized.content
    }
    
    func safeSerialize<E:Encodable>(_ array: [E]) throws -> JsonBinary { try serialize(array.encodable) }
    
    func safeSerialize<E:Encodable>(_ array: [E]) throws -> JsonString? { try serialize(array.encodable) }
    
}

public extension KeyedDecodingContainer {
    
    func safeDeserialize<E:Decodable>(_ key: K) throws -> [E] {
        let deserialized: DecodableArray<E> = try deserialize(key)
        return deserialized.content
    }
    
}

public extension KeyedEncodingContainer {
    
    mutating func safeSerialize<E:Encodable>(_ array: [E], forKey key: K) throws {
        try encode(array.encodable, forKey: key)
    }
    
}

public final class DecodableArray<E:Decodable> : Decodable {

    public let content: [E]

    public init(_ array: [E]) { self.content = array }

    public init(from decoder: Decoder) throws {
        var collection: [E] = [ ]
        do {
            var json: UnkeyedDecodingContainer = try decoder.unkeyedContainer()
            while (json.isAtEnd == false) {
                guard let element: E = try? json.decodeIfPresent(E.self) else { continue }
                collection += element
            }
        } catch {
            log(error: "[CodableArray] unable to deserialize. \(error)")
        }
        self.content = collection
    }
    
}

public final class EncodableArray<E:Encodable> : Encodable {

    public let content: [E]

    public init(_ array: [E]) { self.content = array }

    public func encode(to encoder: Encoder) throws {
        var serializer: UnkeyedEncodingContainer = encoder.unkeyedContainer()
        content.forEach { try? serializer.encode($0) }
    }
    
}

public extension Array where Element:Encodable {
    
    var encodable: EncodableArray<Element> { .init(self) }
    
}
