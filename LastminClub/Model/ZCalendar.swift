//
//  ZCalendar.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import Foundation

class CalendarDay {
    var date: Date
    var inMonth: Bool = true
    
    init(_ date: Date, _ inMonth: Bool = true) {
        self.date = date
        self.inMonth = inMonth
    }
}

class CalendarMonth {
    var month: Int
    var year: Int
    var dayList: [CalendarDay] = [CalendarDay]()
    var selDate0: Date?
    var selDate1: Date?
    
    let isSelectPeriod = false
    
    init(year: Int, month: Int) {
        self.year = year
        self.month = month
        
        self.dayList = setupDayList(year, month)
    }
    init (date: Date) {
        self.year = date.year()
        self.month = date.month()
        
        self.dayList = setupDayList(year, month)
    }
}

// MARK: - setupDayList
extension CalendarMonth {
    func setupDayList(_ year: Int, _ month: Int) -> [CalendarDay] {
        var dayList: [CalendarDay] = []// 7*6 = 42
        let skipCount = CalendarMonth.getSkipCount(CalendarMonth.numFirstWeekDay(year, month))
        // до месяца
        if skipCount != 0 {
            for i in (1...skipCount).reversed() {
                let date = firstDate().addDay(-i)
                dayList.append(CalendarDay(date, false))
            }
        }
        // внутри месяца
        let maxDay = Date.countDaysInMonth(year, month)
        for i in 1...maxDay {
            let dateComponents = DateComponents(year: year, month: month, day: i)
            let calendar = Calendar.current
            if let date = calendar.date(from: dateComponents) {
                dayList.append(CalendarDay(date.startOfDay()))
            }
        }
        // после месяца
        while dayList.count < 42 {
            let date = dayList[dayList.count - 1].date.addDay(1).startOfDay()
            dayList.append(CalendarDay(date, false))
        }
        
        return dayList
    }
    func nameMonth() -> String {
        switch self.month {
        case 1: return "January"
        case 2: return "February"
        case 3: return "March"
        case 4: return "April"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "August"
        case 9: return "September"
        case 10: return "October"
        case 11: return "November"
        case 12: return "December"
        default: return ""
        }
    }
    func firstDate() -> Date {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)!.startOfDay()
    }
    static func numFirstWeekDay(_ year: Int, _ month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents) {
            let day = calendar.component(.weekday, from: date)
            return day
        }// 1=вс, 2=пн, 3=вт, .., 7=сб
        return 0
    }
    static func getSkipCount(_ weekDayNo: Int) -> Int {
        switch weekDayNo {
        case 1: return 6 // (1->6=вс)
        case 2: return 0 // (2->0=пн)
        case 3: return 1 // (3->1=вт)
        case 4: return 2 // (4->2=ср)
        case 5: return 3 // (5->3=чт)
        case 6: return 4 // (6->4=пт)
        case 7: return 5 // (7->5=сб)
        default: return 0
        }
    }
}
// MARK: - SelectedDate
extension CalendarMonth {
    func selectDate(_ date: Date) -> [IndexPath] {
        var list: [IndexPath] = []
        if isSelectPeriod {
            if (selDate0 == nil) && (selDate1 == nil) {
                selDate0 = date
                if let indexPath = getIndexPathByDate(date) { list.append(indexPath) }
            }
            else if (selDate0 != nil) && (selDate1 == nil) {
                if selDate0! < date {
                    selDate1 = date
                    list = getIndexPathByIntervalDate(selDate0!, selDate1!)
                }
            }
            else if let selDate0 = self.selDate0, let selDate1 = self.selDate1 {
                list = getIndexPathByIntervalDate(selDate0, selDate1)
                
                self.selDate0 = date
                self.selDate1 = nil
                if let indexPath = getIndexPathByDate(date) { list.append(indexPath) }
            }
        } else {
            if let selDate = self.selDate0, selDate != date {
                if let indexPath = getIndexPathByDate(selDate) { list.append(indexPath) }
                if let indexPath = getIndexPathByDate(date) { list.append(indexPath) }
            } else {
                if let indexPath = getIndexPathByDate(date) { list.append(indexPath) }
            }
            self.selDate0 = date
        }
        
        return list
    }
    func getIndexPathByDate(_ date: Date) -> IndexPath? {
        guard let index = dayList.firstIndex(where: { $0.date == date }) else { return nil }
        return IndexPath(row: index, section: 0)
    }
    func getIndexPathByIntervalDate(_ date0: Date, _ date1: Date) -> [IndexPath] {
        var list: [IndexPath] = []
        var date = date0
        while date <= date1 {
            if let indexPath = getIndexPathByDate(date) { list.append(indexPath) }
            date = date.addDay(1)
            //print(date)
        }
        return list
    }
}

extension Date {
    static func countDaysInMonth(_ year: Int, _ month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents), let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: date) {
            return numberOfDaysInMonth.count
        }
        return 0
    }
}
