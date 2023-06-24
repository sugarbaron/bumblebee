//
//  LogRecord.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

import Foundation

public extension Log {

    final class Record {

        public let id: Int
        public let message: String
        public let time: Date
        public let file: String
        public let line: Int
        public let method: String
        public let level: Level

        public init(id: Int,
                    message: String,
                    time: Date,
                    file: String,
                    line: Int,
                    method: String,
                    level: Level) {

            self.id = id
            self.message = message
            self.time = time
            self.file = file
            self.line = line
            self.method = method
            self.level = level
        }

    }

}
