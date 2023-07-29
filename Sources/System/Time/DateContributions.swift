//
//  DateContributions.swift
//  Bumblebee
//
//  Created by sugarbaron on 24.10.2022.
//

import Foundation

public extension String {

    /// `"yyyy-MM-dd HH:mm:ss" timeZone: utc`
    var date: Date? { DateFormatter.with("yyyy-MM-dd HH:mm:ss", TimeZoneId.utc.seconds).date(from: self) }

    func date(template: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZoneId = .utc) -> Date? {
        DateFormatter.with(template, timeZone.seconds).date(from: self)
    }

    func date(template: String = "yyyy-MM-dd HH:mm:ss", timeZoneHours hours: Double) -> Date? {
        let timeZoneSeconds: Int = .init(hours * 3600)
        return DateFormatter.with(template, timeZoneSeconds).date(from: self)
    }

}
