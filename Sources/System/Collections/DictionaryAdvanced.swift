//
//  DictionaryAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 17.02.2022.
//

public extension Dictionary {

    var isNotEmpty: Bool { isEmpty == false }
    
    func union(with dictionary: [Key : Value]) -> [Key : Value] {
        var result: [Key : Value] = self
        result += dictionary
        return result
    }
    
    func exclude(_ dictionary: [Key : Value]) -> [Key : Value] {
        var result: [Key : Value] = self
        result -= dictionary
        return result
    }

    static func +=(lhs: inout [Key : Value], rhs: [Key : Value]) { rhs.forEach { lhs[$0] = $1 } }
    
    static func -=(lhs: inout [Key : Value], rhs: [Key : Value]) { rhs.forEach { lhs.removeValue(forKey: $0.key) } }
    
}

public extension Dictionary where Key == String {
    
    func convert() -> [Int : Value] {
        reduce(into: [ : ]) { map, accordance in
            guard let key: Int = accordance.key.int else { return }
            map[key] = accordance.value
        }
    }
    
}
