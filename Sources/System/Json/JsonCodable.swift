//
//  JsonCodable.swift
//  bumblebee
//
//  Created by sugarbaron on 08.11.2022.
//

public protocol JsonCodable : JsonDecodable & JsonEncodable { }

public protocol JsonDecodable : Decodable {
    
    associatedtype Key : CodingKey
    
    static func deserialize(with json: Deserializer) throws -> Self
    
    typealias Deserializer = KeyedDecodingContainer<Key>
    
}

public extension JsonDecodable {
    
    init(from decoder: Decoder) throws {
        let json: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        do    { self = try Self.deserialize(with: json) }
        catch { throw Exception("[Deserializable] unable to deserialize:[\(name(of: Self.self))]: \(error)") }
    }
    
}

public protocol JsonEncodable : Encodable {
    
    associatedtype Key : CodingKey
    
    func serialize(with json: inout Serializer) throws
    
    typealias Serializer = KeyedEncodingContainer<Key>
    
}

public extension JsonEncodable {
    
    func encode(to encoder: Encoder) throws {
        var json: Serializer = encoder.container(keyedBy: Key.self)
        do    { try serialize(with: &json) }
        catch { throw Exception("[Serializable] unable to serialize:[\(name(of: Self.self))]: \(error)") }
    }
    
}
