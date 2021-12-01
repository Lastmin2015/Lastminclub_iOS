//
//  DataSearchTour.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 30.04.2021.
//

import Foundation

class DataSearchTour: Codable {
    var pointOrig: String?
    var pointDest: String?
    var date0: Date?
    var date1: Date?
    var countAdult: Int = 0
    var countChild: Int = 0
    var ageChildDict: [Int: Int] = [:]
}

// MARK: - HelpersFunctions
extension DataSearchTour {
    func periodStr() -> String {
        guard let d0 = date0, let d1 = date1 else { return "" }
        return "\(d0.toString(df4_MMMDD)) - \(d1.toString(df4_MMMDD))"
    }
    func travellersStr() -> String {
        var res: String = ""
        if countAdult != 0 { res = "\(countAdult) Adults" }
        if countChild != 0 { res = res.addPart("\(countChild) Childs", ", ") }
        return res
    }
}

// MARK: - Save/Load Loacally
extension DataSearchTour {
    func saveLastLocally() { LocallyData.save_klastDataSearchTour(self) }
    static func loadLastLocally() -> DataSearchTour? {
        return LocallyData.load_klastDataSearchTour()
    }
}
