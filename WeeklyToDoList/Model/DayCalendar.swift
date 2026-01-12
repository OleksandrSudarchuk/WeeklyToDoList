//
//  DayCalendar.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 07/01/2026.
//

import Foundation

enum DayCalendar {
    static let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .autoupdatingCurrent
        return cal
    }()
    
    static func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
    
    static func nextDay(from date: Date) -> Date {
        calendar.date(byAdding: .day, value: 1, to: date)!
    }
}
