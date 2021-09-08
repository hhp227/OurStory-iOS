//
//  DateUtil.swift
//  Application
//
//  Created by 홍희표 on 2021/09/07.
//  Copyright © 2021 홍희표. All rights reserved.
//

import Foundation

class DateUtil {
    static func parseDate(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString) ?? Date()
    }

    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        formatter.dateFormat = "M d, y"
        return formatter.string(from: date)
    }
    
    static func getPeriodTimeGenerator(_ date: Date) -> String {
        let millisecs = Date().timeIntervalSince1970 - date.timeIntervalSince1970
        let secs = Int(millisecs)
        let mins = secs / 60
        let hours = mins / 60
        let days = hours / 24
        
        if days > 1 {
            return formatDate(date)
        } else if days > 0 {
            return String(format: "%dday ago", days)
        } else if hours > 0 {
            return String(format: "%dhour ago", hours)
        } else if mins > 0 {
            return String(format: "%dminute ago", mins)
        } else if secs > 1 {
            return String(format: "%dsecond ago", secs)
        } else if secs < 2 {
            return String(format: "now", secs)
        } else {
            return formatDate(date)
        }
    }
}
