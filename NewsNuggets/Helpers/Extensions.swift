//
//  Extensions.swift
//  NewsNuggets
//
//  Created by Mostafa Alaa on 06/12/2023.
//

import Foundation

extension String {
    func formatted(with args: [String]?) -> String {
        guard let args = args, args.count > 0 else {
            return self
        }

        var data = self
        for i in 0...args.count - 1 {
            data =  data.replacingOccurrences(of: "{\(i)}", with: args[i])
        }
        return data
    }
    func getDateFromString() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter.date(from: self)
    }

    func toDateTime() -> Date? {
        let dateFormatter = DateFormatter()
        let formats = ["yyyy-MM-dd'T'HH:mm:ss.S'Z'", "yyyy-MM-dd'T'HH:mm:ss.S", "yyyy-MM-dd'T'HH:mm:ss", "dd-MM-yyyy", "dd-MM-yyyy hh:mm a", "yyyy-MM-dd'T'HH:mm:ss.SZ", "yyyy-MM-dd HH:mm:ss Z", "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ", "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", "yyyy-MM-dd'T'HH:mm:ss'Z'", "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX", "yyyy-MM-dd", "HHmm", "hh:mm a", "h:mm a"]
        for item in formats {
            dateFormatter.dateFormat = item
            if let dateFromString: Date = dateFormatter.date(from: self) {
                return dateFromString
            }
        }
        return nil
    }
}
extension Date {
    struct Date_ {
        static let formatter = DateFormatter()
    }
    var dayMonthYear: String {
        Date_.formatter.dateFormat = "d MMM y"
        return Date_.formatter.string(from: self)
    }
    var ddMMMyyyyDashed: String {
        Date_.formatter.dateFormat = "dd-MMM-yyyy"
        return Date_.formatter.string(from: self)
    }
    var yyyyMMddDashed: String {
        Date_.formatter.dateFormat = "yyyy-MM-dd"
        return Date_.formatter.string(from: self)
    }
    var ddMMMyyyy: String {
        Date_.formatter.dateFormat = "dd MMM yyyy"
        return Date_.formatter.string(from: self)
    }
    var LLLLyyyy: String {
        Date_.formatter.dateFormat = "LLLL yyyy"
        return Date_.formatter.string(from: self)
    }
    var dayString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    var timeString: String {
        Date_.formatter.dateFormat = "h:mm a"
        return Date_.formatter.string(from: self)
    }
    var fullDate: String {
        // 24 Dec 2021, 11:06 AM
        Date_.formatter.dateFormat = "dd MMM yyyy, h:mm a"
        return Date_.formatter.string(from: self)
    }
    var getDayNum: Int {
        // get day number as google places make
        let dayString = self.dayString
        let weekdays = [0: "Sunday", 1: "Monday", 2: "Tuesday", 3: "Wednesday", 4: "Thursday", 5: "Friday", 6: "Saturday"]
        let dayNum = weekdays.first { item in
            item.value == dayString
        }
        return dayNum?.key ?? 0
    }
    var fullMonthDateFormat: String {
        // 24 December 2022, 11:06 AM
        Date_.formatter.dateFormat = "dd MMMM yyyy, hh:mm a"
        return Date_.formatter.string(from: self)
    }
    var dMMMMyyyy: String {
        // 8 January 2023
        Date_.formatter.dateFormat = "d MMMM yyyy"
        return Date_.formatter.string(from: self)
    }
    var fullDate_spaces: String {
        // 4 Dec 2021  11:06 AM
        Date_.formatter.dateFormat = "d MMM yyyy  h:mm a"
        return Date_.formatter.string(from: self)
    }
}
