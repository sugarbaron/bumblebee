//
//  Exception.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

public final class Exception : Error {

    public let type: ExceptionType
    public let cause: String

    public enum ExceptionType: String {
        case illegalState = "illegalState"
        case illegalArgument = "illegalArgument"
        case outOfRange = "outOfRange"
        case actionFailed = "actionFailed"
    }

    public init(_ cause: String = "",
         type: ExceptionType = .actionFailed,
         file: String = #file,
         method: String = #function,
         line: Int = #line) {
        
        self.type = type
        self.cause = cause
        if cause.isEmpty { return }
        log(error: "[\(type.rawValue)] \(cause)", file: file, method: method, line: line)
    }

}

extension Exception : CustomStringConvertible {

    public var description: String { cause }

}
