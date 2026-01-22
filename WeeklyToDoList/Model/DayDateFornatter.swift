//
//  DayDateFornatter.swift
//  WeeklyToDoList
//
//  Created by Oleksandr Sudarchuk on 13/01/2026.
//

import Foundation

enum DayDateFornatter {
    static let formatter: DateFormatter = {
        let df = DateFormatter()
        df.calendar = DayCalendar.calendar
        df.timeZone = DayCalendar.calendar.timeZone
        df.locale = .current
        df.dateStyle = .full
        df.timeStyle = .none
        return df
    }()
    static func title(for date: Date) -> String {
        formatter.string(from: date)
    }
}
