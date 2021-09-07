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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString) ?? Date()
    }

    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    static func getPeriodTimeGenerator(_ date: Date) -> String {
        let writeDatetime = date.timeIntervalSince1970
        let nowDate = Date().timeIntervalSince1970
        let millisecond = nowDate - writeDatetime
        print("writeDate: \(writeDatetime), nowDate: \(nowDate), millisec: \(millisecond)")
        return ""
    }
}

extension Date {
    var millisecondSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(millisecond: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millisecond) / 1000)
    }
}
