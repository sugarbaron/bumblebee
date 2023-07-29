//
//  LogEngine.swift
//  Bumblebee
//
//  Created by sugarbaron on 20.10.2022.
//

import Foundation

public extension Log {

    final class Engine {

        private var storage: Log.Storage?
        private let background: Async.Fifo

        public init() {
            self.storage = nil
            self.background = Async.Fifo()
        }

    }

}

extension Log.Engine {

    internal func record(into storage: Log.Storage?) { self.storage = storage }

    internal func log(_ level: Level, _ message: String, file filePath: String, method: String, line: Int) {
        let time: Date = Date()
        background.enqueue { [weak self, time] in
            print("[\(level.symbolic)][\(time.utcPrecise)] \(message)")
            guard let storage: Log.Storage = self?.storage else { return }
            storage.save(Log.Record.Draft(message: message,
                                          time: time,
                                          file: filePath.fileName,
                                          line: line,
                                          method: method,
                                          level: level))
        }
    }

    internal typealias Level = Log.Record.Level

}

private extension String {

    var fileName: String {
        guard let fileUrl: URL = .init(string: self) else { return "<filename_unknown>" }
        return fileUrl.lastPathComponent
    }

}
