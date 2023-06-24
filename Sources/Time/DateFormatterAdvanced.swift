//
//  DateFormatterAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.11.2021.
//

import Foundation

public extension DateFormatter {

    static func with(_ template: String, _ timeZone: TimeZoneId = .utc) -> DateFormatter {
        create(template, timeZone.seconds)
    }

    static func with(_ template: String, _ timeZoneHours: Double) -> DateFormatter {
        let secondsFromGMT = Int(timeZoneHours * 3600)
        return create(template, secondsFromGMT)
    }

    static func with(_ template: String, _ secondsFromGmt: Int) -> DateFormatter {
        create(template, secondsFromGmt)
    }

    private static func create(_ template: String, _ secondsFromGmt: Int) -> DateFormatter {
        let converter = DateFormatter()
        converter.dateFormat = template
        converter.locale = Locale(identifier: "en_US_POSIX")
        converter.calendar = Calendar(identifier: .iso8601)
        converter.timeZone = TimeZone(secondsFromGMT: secondsFromGmt)
        return converter
    }

}
