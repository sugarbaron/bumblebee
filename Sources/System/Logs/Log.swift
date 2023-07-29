//
//  Log.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

import Foundation

public class Log {

    internal static weak var engine: Engine? = nil

    public static func record(into storage: Log.Storage?) { engine?.record(into: storage) }

    internal static func constructEngine() -> Engine? {
        let engine: Engine = .init()
        Log.engine = engine
        return engine
    }

}

public func log(_ info: String, file: String = #file, method: String = #function, line: Int = #line) {
    Log.engine?.log(.info, info, file: file, method: method, line: line)
}

public func log(error: String, file: String = #file, method: String = #function, line: Int = #line) {
    Log.engine?.log(.error, error, file: file, method: method, line: line)
}

public func log(warning: String, file: String = #file, method: String = #function, line: Int = #line) {
    Log.engine?.log(.warning, warning, file: file, method: method, line: line)
}

public func log<T:Nullable>(nil error: String, file: String = #file, method: String = #function, line: Int = #line)
-> T {
    Log.engine?.log(.error, error, file: file, method: method, line: line); return nil
}
