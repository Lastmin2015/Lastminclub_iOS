//
//  Date.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 06.04.2021.
//

import Foundation

//MARK: - Date
public let df0_yyyyMMddHHmmss = "yyyyMMddHHmmss"
public let df1_ddMMyyyy = "dd/MM/yyyy"
public let df2_ddMMMMyyyy = "dd MMMM yyyy"
public let df3_dMM = "d.MM"
public let df4_MMMDD  = "MMM dd"
public let dF5_yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"//"2020-08-11T14:32:41.000000Z"
public let dF6_EEEE_ddMMMMyyyy = "EEEE, dd MMMM yyyy"
public let dF7_Hmm = "H:mm"
//public let dateF2_yyyyMMdd = "yyyy.MM.dd"
//public let dateF3_ddMMyyyy_HHmm = "dd.MM.yyyy HH:mm"
//public let dateF4_yyyyMMdd_HHmm = "yyyy.MM.dd HH:mm"
//public let dateF5_HHmm = "HH:mm"
//public let dateF_d_MMMM = "d MMMM"
//public let dateF_EEEE_HHmm = "EEEE HH:mm"
//public let dateF4_yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"//"2020-08-11T14:32:41.000000Z"
//2020-05-03T19:20:30+01:00 yyyy-MM-dd'T'HH:mm:ssZ


// MARK: ConvertType
extension Date {
    func dateFormatter(_ dateFormat: String, _ secondsFromGMT: Int = TimeZone.current.secondsFromGMT()) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale.current //Locale(identifier: "ru")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }
    func toString(_ dateFormat: String, _ secondsFromGMT: Int = TimeZone.current.secondsFromGMT()) -> String {
        return dateFormatter(dateFormat, secondsFromGMT).string(from: self)
    }
    func toStringZ0(_ dateFormat: String) -> String {
        return dateFormatter(dateFormat, 0).string(from: self)
    }
}
extension String {
    func toDate(_ dateFormat: String, _ secondsFromGMT: Int = TimeZone.current.secondsFromGMT()) -> Date? {
        return Date().dateFormatter(dateFormat, secondsFromGMT).date(from: self)
    }
}

// MARK: - Convert
extension Date {
    static func secondsToString(_ seconds: Int, _ allowedUnits: NSCalendar.Unit = [.hour, .minute]) -> String {
        var formatter: DateComponentsFormatter {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = allowedUnits//[.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            return formatter
        }
        return formatter.string(from: Double(seconds)) ?? "00:00:00"
    }
    static func secondsToTimeParts(_ seconds : Int) -> String {
        let (h,m,s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
        //            let h_string = h < 10 ? "0\(h)" : "\(h)"
        //            let m_string =  m < 10 ? "0\(m)" : "\(m)"
        //            //let s_string =  s < 10 ? "0\(s)" : "\(s)"
        //            return "\(h_string) h \(m_string) m"
        
        return "\(h) h \(m) m"
    }
}

// MARK: - Компоненты, операции дат
extension Date {
    func getByDateTime(time: Date) -> Date {
        let dateComponents = DateComponents(year: self.year(),
                                            month: self.month(),
                                            day: self.day(),
                                            hour: time.hour(),
                                            minute: time.minute(),
                                            second: time.second())
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!
    }
    
    func year() -> Int { return Calendar.current.component(.year, from: self) }
    func month() -> Int { return Calendar.current.component(.month, from: self) }
    func day() -> Int { return Calendar.current.component(.day, from: self) }
    func hour() -> Int { return Calendar.current.component(.hour, from: self) }
    func minute() -> Int { return Calendar.current.component(.minute, from: self) }
    func second() -> Int { return Calendar.current.component(.second, from: self) }
    func weekday() -> Int { return Calendar.current.component(.weekday, from: self) }
    
    func startOfDay() -> Date {
        let day = Calendar.autoupdatingCurrent.dateInterval(of: .day, for: self)!
        return day.start
    }
    
    func addMonth(_ value: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.month = value
        return Calendar.current.date(byAdding: dateComponent, to: self)!
    }
    func addDay(_ value: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = value
        return Calendar.current.date(byAdding: dateComponent, to: self)!
    }
}
