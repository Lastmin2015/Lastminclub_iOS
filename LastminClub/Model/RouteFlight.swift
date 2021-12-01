//
//  RouteFlight.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 22.06.2021.
//

import Foundation

/*
 "id": "1729032d499f00008f6d20ba_0",
 "combination_id": "1729032d499f00008f6d20ba",
 "fly_from": "FRA",
 "fly_to": "STN",
 "city_from": "Frankfurt",
 "city_code_from": "FRA",
 "city_to": "London",
 "cityCodeTo": "LON",
 "airline": "FR",
 "flight_no": 1686,
 "operating_carrier": "FR",
 "operating_flight_no": "1686",
 "fare_basis": "",
 "fare_category": "M",
 "fare_classes": "",
 "fare_family": "",
 "return": 0,
 "bags_recheck_required": false,
 "guarantee": false,
 "last_seen": "2021-06-22T08:00:04Z",
 "refresh_timestamp": "2021-06-22T08:00:04Z",
 "equipment": null,
 "vehicle_type": "aircraft",
 "local_arrival": "2021-08-08T06:55:00Z",
 "utc_arrival": "2021-08-08T05:55:00Z",
 "local_departure": "2021-08-08T06:25:00Z",
 "utc_departure": "2021-08-08T04:25:00Z"
 */

class RouteFlight: Codable {
    var id: String
    var cityFrom: City
    var cityTo: City
    var dateDeparture: Date
    var dateArrival: Date
    var duration: Int //second
    var airline: String
    var flightNo: String
    var category: String = "no API: Economy"
    var timeConnection: Int? = nil
    
    // MARK: - Initializers
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let cityFromName = json["city_from"] as? String,
            let cityFromId = json["city_code_from"] as? String,
            let cityToName = json["city_to"] as? String,
            let cityToId = json["cityCodeTo"] as? String,
            let dateDepartureStr = json["local_departure"] as? String,
            let dateArrivalStr = json["local_arrival"] as? String,
            let dateDeparture = dateDepartureStr.toDate(dF5_yyyyMMddTHHmmssZ, 0),
            let dateArrival = dateArrivalStr.toDate(dF5_yyyyMMddTHHmmssZ, 0),
            let dateDepartureUTCStr = json["utc_departure"] as? String,
            let dateArrivalUTCStr = json["utc_arrival"] as? String,
            let dateDepartureUTC = dateDepartureUTCStr.toDate(dF5_yyyyMMddTHHmmssZ, 0),
            let dateArrivalUTC = dateArrivalUTCStr.toDate(dF5_yyyyMMddTHHmmssZ, 0),
            let airline = json["airline"] as? String,
            let flightNo = json["operating_flight_no"] as? String
        else { return nil }
        
        self.id = id
        self.cityFrom = City(id: cityFromId, name: cityFromName)
        self.cityTo = City(id: cityToId, name: cityToName)
        self.dateDeparture = dateDeparture
        self.dateArrival = dateArrival
        self.duration = Int(dateArrivalUTC.timeIntervalSince(dateDepartureUTC))
        self.airline = airline
        self.flightNo = flightNo
    }
}

/*
 "combination_id": "1729032d499f00008f6d20ba",
 "airline": "FR",
 "flight_no": 1686,
 "operating_carrier": "FR",
 "operating_flight_no": "1686",
 "fare_basis": "",
 "fare_category": "M",
 "fare_classes": "",
 "fare_family": "",
 "return": 0,
 "bags_recheck_required": false,
 "guarantee": false,
 "last_seen": "2021-06-22T08:00:04Z",
 "refresh_timestamp": "2021-06-22T08:00:04Z",
 "equipment": null,
 "vehicle_type": "aircraft",
 */

// MARK: - API
extension RouteFlight {
    //func getDict() -> [String: Any]? { return self.values }
    static func loadList(_ dict: [[String: Any]]) -> [RouteFlight] {
        var list: [RouteFlight] = []
        dict.forEach { (json) in
            guard let item = RouteFlight.init(json: json) else { return }
            list.append(item)
        }
        return list
    }
}

// MARK: - AdaptationModel
extension RouteFlight {
    static func adaptationList(_ list: [RouteFlight]) {
        for (index, item) in list.enumerated() {
            guard index < (list.count-1) else { return }
            let nextRoute = list[index+1]
            item.timeConnection = Int(nextRoute.dateDeparture.timeIntervalSince(item.dateArrival))
        }
    }
}
