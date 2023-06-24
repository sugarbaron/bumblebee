//
//  DateRange.swift
//  Bumblebee
//
//  Created by sugarbaron on 06.07.2021.
//

import Foundation

public extension Date {
    
    enum Range : String, Codable {
        
        case lastWeek = "last_week"
        case today = "today"
        case tomorrow = "tomorrow"
        case thisWeek = "this_week"
        case allTime = "all_time"
        
        private static let dayDuration: TimeInterval = 24 * 60 * 60
        private static let weekDuration: TimeInterval = 7 * dayDuration

        public var interval: (from: Date, to: Date)? {
            switch self {
            case .lastWeek: return lastWeekInterval
            case .today:    return todayInterval
            case .tomorrow: return tomorrowInterval
            case .thisWeek: return thisWeekInterval
            case .allTime:  return allTimeInterval
            }
        }
        
        private var tomorrowInterval: (from: Date, to: Date)? {
            guard let today: (from: Date, to: Date) = todayInterval else { return nil }
            let tomorrowStart: Date = today.from.addingTimeInterval(Range.dayDuration)
            let tomorrowEnd: Date = today.to.addingTimeInterval(Range.dayDuration)
            return (tomorrowStart, tomorrowEnd)
        }
        
        private var todayInterval: (from: Date, to: Date)? {
            let now: Date = Date.now
            let components: DateComponents = Calendar.current.dateComponents(Set([.year, .month, .day]), from: now)
            guard let today: Date = Calendar.current.date(from: components)
            else { log(error: "[DateRange] unable to construct today date"); return nil }
            let tomorrow: Date = today.addingTimeInterval(Range.dayDuration - 1)
            return (today, tomorrow)
        }
        
        private var allTimeInterval: (from: Date, to: Date)? {
            guard let thisWeek: (from: Date, to: Date) = thisWeekInterval else { return nil }
            return (thisWeek.from.addingTimeInterval(-Range.weekDuration), thisWeek.to)
        }
        
        private var lastWeekInterval: (from: Date, to: Date)? {
            guard let thisWeek: (from: Date, to: Date) = thisWeekInterval else { return nil }
            let lastWeekStart: Date = thisWeek.from.addingTimeInterval(-Range.weekDuration)
            let lastWeekEnd: Date = thisWeek.from.addingTimeInterval(-1)
            return (lastWeekStart, lastWeekEnd)
        }
        
        private var thisWeekInterval: (from: Date, to: Date)? {
            let calendar: Calendar = Calendar(identifier: .iso8601)
            let components: DateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date.now)
            guard let monday: Date = calendar.date(from: components)
            else { log(error: "[DateRange] unable to construct this week date"); return nil }
            let nextMonday: Date = monday.addingTimeInterval(Range.weekDuration - 1)
            return (monday, nextMonday)
        }
        
    }
    
}
