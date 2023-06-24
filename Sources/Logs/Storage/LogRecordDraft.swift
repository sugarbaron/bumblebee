//
//  LogRecordDraft.swift
//  Bumblebee
//
//  Created by sugarbaron on 21.10.2022.
//

import Foundation

public extension Log.Record {

    final class Draft {

        public let message: String
        public let time: Date
        public let file: String
        public let line: Int
        public let method: String
        public let level: Level

        public init(message: String,
                    time: Date,
                    file: String,
                    line: Int,
                    method: String,
                    level: Level) {

            self.message = message
            self.time = time
            self.file = file
            self.line = line
            self.method = method
            self.level = level
        }

    }

}
