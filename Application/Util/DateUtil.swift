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
        formatter.dateFormat = "yyyy/MM/dd"

        return formatter.string(from: date)
    }
}
