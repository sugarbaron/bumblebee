//
//  JsonCodingTools.swift
//  bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

public extension KeyedDecodingContainer {

    func deserialize<T:Decodable>(_ key: K) throws -> T { try self.decode(T.self, forKey: key) }
    
    func deserialize<T:Decodable>(optional key: K) throws -> T? { try decodeIfPresent(T.self, forKey: key) }

    func nestedDeserializer<T:CodingKey>(for key: K) throws -> KeyedDecodingContainer<T> {
        try nestedContainer(keyedBy: T.self, forKey: key)
    }
    
}

public extension KeyedEncodingContainer {
    
    mutating func serialize<T:Encodable>(_ original: T, key: KeyedEncodingContainer.Key) throws {
        try self.encode(original, forKey: key)
    }
    
}

public extension UnkeyedDecodingContainer {

    /// brown magic (crutch) for ability to skip json elements with UnkeyedDecodingContainer
    mutating func skipElement() { _ = try? decode(DecodableStub.self) }

}

private final class DecodableStub : Decodable { }
