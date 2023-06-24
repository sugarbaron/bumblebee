//
//  LogRecordLevel.swift
//  Bumblebee
//
//  Created by sugarbaron on 21.10.2022.
//

public extension Log.Record {

    enum Level : Int {

        case info = 0
        case error = 1
        case warning = 2

        public init(code: Int) { self = .init(rawValue: code) ?? .info }

        public var code: Int { rawValue }

        public var symbolic: String {
            switch self {
            case .info: return " "
            case .error: return "x"
            case .warning: return "!"
            }
        }

    }

}
