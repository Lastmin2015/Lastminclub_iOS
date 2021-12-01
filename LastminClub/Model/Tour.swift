//
//  Tour.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 26.04.2021.
//

import Foundation

class Tour {
    var id: String
    var date0: Date?
    var date1: Date?
    var price: Double = 0
    var countAdult: Int = 0
    var countChild: Int = 0
    var adultDict: [Int: User] = [:]
    var childDict: [Int: User] = [:]
    var hotel: Hotel?
    var flight0: Flight?
    var flight1: Flight?
    
    //Extra
    var flightList: [Flight] {
        var list: [Flight] = []
        if let flight = flight0 { list.append(flight) }
        if let flight = flight1 { list.append(flight) }
        return list
    }
    var fDetailsPorts: String? {
        guard let flight = flight0 else { return nil }
        return "\(flight.cityFrom.id) - \(flight.cityTo.id)"
    }
    var fDetailsTimeLabel: String? {
        guard let flight = flight0 else { return nil }
        let countStops = flight.countStops
        let countStopsStr = (countStops == 0) ? "Direct" : "\(countStops) Stops"
        return "\(countStopsStr), - \(Date.secondsToTimeParts(flight.duration))"
    }
    
    // MARK: - Initializers
    init?(json: JSON) {
        guard
            let id = json["id"] as? String,
            let price = json["price"] as? Double,
            let countAdult = json["num_adults"] as? Int,
            let countChild = json["num_children"] as? Int,
            let tourDict = json["tour"] as? JSON
        else { return nil }

        self.id = id
        self.price = price
        self.countAdult = countAdult
        self.countChild = countChild
        
        // Hotel
        guard let hotelDict = tourDict["hotel"] as? JSON,
              let hotel = Hotel(json: hotelDict)
        else { return nil }
        self.hotel = hotel
        
        // flight
        flight0 = Flight(json: tourDict["outbound_flight"] as? JSON ?? [:])
        flight1 = Flight(json: tourDict["return_flight"] as? JSON ?? [:])
    }
}
/*
https://apitest.fun:9595/api/v1/tour-tickets/search?
 end_date=1638298800&
 start_date=1635706800&
 destination=%25C4%25B0zmir&
 with_data=true&locale=en&
 origin=Tenerife
https://apitest.fun:9595/api/v1/tour-tickets/search?
 origin=Tenerife
 &with_data=true&
 destination=%C4%B0zmir&
 start_date=1635706800&
 end_date=1638298800&locale=en
*/

// MARK: - HelpersFunctions
extension Tour {
    func periodStr() -> String {
        guard let d0 = date0, let d1 = date1 else { return "" }
        return "\(d0.toString(df3_dMM))-\(d1.toString(df3_dMM))"
    }
    func priceStr() -> String { self.price.toMoney() }
}

// MARK: - API
extension Tour {
    static func loadList(_ dict: [JSON]) -> [Tour] {
        return dict.compactMap { Tour.init(json: $0) }
    }
}

// MARK: - Demo
extension Tour {
    static func demoList() -> [Tour] {
        return []//demo1(), demo2(), demo1(), demo2(),]
    }
//    static func demo1() -> Tour {
//        let item = Tour()
//        item.hotel = Hotel.demo1()
//        item.date0 = "06/05/2021".toDate(df1_ddMMyyyy)
//        item.date1 = "24/05/2021".toDate(df1_ddMMyyyy)
//        item.price = 1690
//        item.countAdult = 2
//        item.countChild = 1
//        return item
//    }
//    static func demo2() -> Tour {
//        let item = Tour()
//        item.hotel = Hotel.demo2()
//        item.date0 = "01/06/2021".toDate(df1_ddMMyyyy)
//        item.date1 = "14/06/2021".toDate(df1_ddMMyyyy)
//        item.price = 1040
//        item.countAdult = 2
//        item.countChild = 2
//        return item
//    }
}
