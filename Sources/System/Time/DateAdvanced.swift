//
//  DateAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 28.07.2022.
//

import Foundation

// MARK: construction
public extension Date {

    init(since1970 seconds: TimeInterval) { self.init(timeIntervalSince1970: seconds) }

    init(milliseconds: Int64) { self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000) }

}

// MARK: parse/format
public extension Date {

    func `as`(_ template: String, timeZone: TimeZoneId = .utc) -> String {
        formatDate(as: template, timeZone: timeZone.seconds)
    }

    func `as`(_ template: String, timeZoneHours hours: Double) -> String {
        let timeZoneSeconds: Int = .init(hours * 3600)
        return formatDate(as: template, timeZone: timeZoneSeconds)
    }

    var utcPrecise: String { formatDate(as: "yyyy-MM-dd HH:mm:ss.SSSS", timeZone: TimeZoneId.utc.seconds) }

    var utcFull: String { formatDate(as: "yyyy-MM-dd HH:mm:ss", timeZone: TimeZoneId.utc.seconds) }

    var utcShort: String { formatDate(as: "yyyy-MM-dd", timeZone: TimeZoneId.utc.seconds) }

    var utcDaytime: String { formatDate(as: "HH:mm:ss", timeZone: TimeZoneId.utc.seconds) }

    var full: String { formatDate(as: "yyyy-MM-dd HH:mm:ss", timeZone: TimeZoneId.current.seconds) }

    var short: String { formatDate(as: "yyyy-MM-dd", timeZone: TimeZoneId.current.seconds) }

    var daytime: String { formatDate(as: "HH:mm:ss", timeZone: TimeZoneId.current.seconds) }
    
    func yyyyMMdd(timeZone: TimeZoneId = .utc) -> String { formatDate(as: "yyyy-MM-dd", timeZone: timeZone.seconds) }
    
    func HHmmss(timeZone: TimeZoneId = .utc) -> String { formatDate(as: "HH:mm:ss", timeZone: timeZone.seconds) }

    private func formatDate(as template: String, timeZone secondsFromGMT: Int) -> String {
        let converter: DateFormatter = .with(template, secondsFromGMT)
        return converter.string(from: self)
    }

}

// MARK: constants
public extension Date {

    static let dayDuration: TimeInterval = .init(24 * 60 * 60)

}

// MARK: advancements
public extension Date {

    var since1970: TimeInterval { timeIntervalSince1970 }

    var millisecondsSince1970: Int64 { Int64((timeIntervalSince1970 * 1000.0).rounded()) }
    
    static func -(from: Date, to: Date) -> TimeInterval { from.timeIntervalSince(to) }
    
    func since(_ date: Date) -> TimeInterval { timeIntervalSince(date) }

}

public enum TimeZoneId {

    case current
    case utc

    public var seconds: Int {
        switch self {
        case .utc:     return 0
        case .current: return TimeZone.current.secondsFromGMT()
        }
    }

}

public extension Date {

    var isToday: Bool { isDateInToday }

    var isEarlierThanToday: Bool { isDateEarlierThanToday }

    var isLaterThanToday: Bool { isDateLaterThanToday }

    var isTodayOrLater: Bool { isDateInToday || isDateLaterThanToday }

    var isTodayOrEarlier: Bool { isDateInToday || isDateEarlierThanToday }

    private var isDateInToday: Bool { Calendar.current.isDateInToday(self) }

    private var isDateLaterThanToday: Bool { !isDateInToday && self.timeIntervalSinceNow > 0 }

    private var isDateEarlierThanToday: Bool { !isDateInToday && self.timeIntervalSinceNow < 0 }

}

public extension Date {

    var dayStart: Date? {
        var calendar: Calendar = .init(identifier: .iso8601)
        calendar.timeZone = .current
        return calendar.startOfDay(for: self)
    }
    
    var utcDayStart: Date? {
        guard let timeZone: TimeZone = .init(secondsFromGMT: 0) else { return nil }
        var calendar: Calendar = .init(identifier: .iso8601)
        calendar.timeZone = timeZone
        return calendar.startOfDay(for: self)
    }
    
}

public extension Date {
    
    static var is24HourFormat: Bool? {
        guard let dateFormat: String = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: .current)
        else { return nil }
        return dateFormat.firstIndex(of: "a") == nil
    }
    
}

internal extension Date {
    
    static var now: Date { Date() }
    
}
