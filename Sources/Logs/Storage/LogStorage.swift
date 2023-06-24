//
//  LogStorage.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

import Foundation
import Combine

public extension Log {

    typealias Recorder = LogRecorder
    typealias Reader   = LogReader
    typealias Storage  = Recorder & Reader

}

public protocol LogRecorder : AnyObject {

    func save(_ record: Log.Record.Draft)

}

public protocol LogReader : AnyObject {

    func loadLoggedDays() -> AnyPublisher<[Date], Never>

    func load(forDay day: Date) -> AnyPublisher<[Log.Record], Never>

}
