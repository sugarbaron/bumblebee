//
//  LogContributions.swift
//  Bumblebee
//
//  Created by sugarbaron on 20.10.2022.
//

public extension Optional {

    var printIsNil: String { self == nil ? "<nil>" : "<not_nil>" }

    var log: String { print(self) }

}

// MARK: arrays
public extension Optional where Wrapped == [Int] {
    
    var log: String { unwrap(self) { $0.log } ?? print(self) }
    
}

public extension Optional where Wrapped == [Int?] {
    
    var log: String { unwrap(self) { $0.log } ?? print(self) }
    
}

public extension Optional where Wrapped == [String] {
    
    var log: String { unwrap(self) { $0.log } ?? print(self) }
    
}

public extension Optional where Wrapped == [String?] {
    
    var log: String { unwrap(self) { $0.log } ?? print(self) }
    
}

public extension Array {
    
    var log: String { "[\(map { print($0) }.joined)]" }
    
}

private func print(_ optional: Optional<Any>) -> String { unwrap(optional) { "\($0)" } ?? "<nil>" }
