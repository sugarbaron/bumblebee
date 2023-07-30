//
//  Json.swift
//  bumblebee
//
//  Created by sugarbaron on 27.08.2021.
//

import Foundation

// MARK: constructor
public class Json {
    
    public static let standard: Json = .init()
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init() {
        self.encoder = Json.createEncoder()
        self.decoder = Json.createDecoder()
    }
    
    // MARK: default settings
    private static func createEncoder() -> JSONEncoder {
        let encoder: JSONEncoder = .init()
        encoder.keyEncodingStrategy = .useDefaultKeys
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    private static func createDecoder() -> JSONDecoder {
        let decoder: JSONDecoder = .init()
        decoder.keyDecodingStrategy = .useDefaultKeys
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
}

// MARK: customizations
public extension Json {
    
    func dates(template: String, _ timeZone: TimeZoneId) -> Json {
        encoder.dateEncodingStrategy = .formatted(.with(template, timeZone))
        decoder.dateDecodingStrategy = .formatted(.with(template, timeZone))
        return self
    }
    
    func keys(_ keys: KeysFormat) -> Json {
        switch keys {
        case .asIs:
            encoder.keyEncodingStrategy = .useDefaultKeys
            decoder.keyDecodingStrategy = .useDefaultKeys
        case .snakeCase:
            encoder.keyEncodingStrategy = .convertToSnakeCase
            decoder.keyDecodingStrategy = .convertFromSnakeCase
        case .custom(let strategy):
            encoder.keyEncodingStrategy = .custom(strategy)
            decoder.keyDecodingStrategy = .custom(strategy)
        }
        return self
    }
    
    enum KeysFormat {
        case asIs
        case snakeCase
        case custom(strategy: ([CodingKey]) -> CodingKey)
    }
    
}

// MARK: interface
public extension Json {
    
    func serialize<T:Encodable>(_ value: T) throws -> JsonBinary { try encoder.encode(value) }
    
    func serialize<T:Encodable>(_ value: T) throws -> JsonString? { try encoder.encode(value).string }

    func serialize<T:Encodable>(_ value: T) throws -> [String : Any] {
        let json: JsonBinary = try encoder.encode(value)
        guard let serialized = try JSONSerialization.jsonObject(with: json, options: [ ]) as? [String : Any]
        else { throw Exception("[Json] unable to serialize: \(T.self)") }
        return serialized
    }

    func deserialize<T:Decodable>(_ serialized: JsonBinary, as type: T.Type = T.self) throws -> T {
        do    { return try decoder.decode(T.self, from: serialized) }
        catch { throw Exception("[Json] \(serialized.string.log) error:\(error)") }
    }

    func deserialize<T:Decodable>(_ serialized: JsonString) throws -> T {
        do    { return try decoder.decode(T.self, from: Data(serialized.utf8)) }
        catch { throw Exception("[Json] \(serialized) error:\(error)") }
    }

    static func convert(_ dictionary: [String : Any]) -> JsonBinary? {
        try? JSONSerialization.data(withJSONObject: dictionary)
    }

    static func convert(_ dictionary: [String : Any]) -> JsonString? {
        guard let data: Data = try? JSONSerialization.data(withJSONObject: dictionary) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func convert(_ json: JsonString) -> [String : Any]? {
        guard let data: Data = json.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }

}

public typealias JsonString = String
public typealias JsonBinary = Data
