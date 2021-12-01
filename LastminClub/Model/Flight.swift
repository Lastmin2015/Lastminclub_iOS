//
//  Flight.swift
//  LastminClub
//
//  Created by Aleksandr Zorin on 22.06.2021.
//

import Foundation
/*
 {
            "id": "60d18cc495ca290001b9e259",
            "fly_from": "FRA",
            "fly_to": "PRG",
            "date_from": 1631404800,
            "date_to": 1633996800,
            "city_from": "Frankfurt",
            "city_code_from": "FRA",
            "city_to": "Prague",
            "city_code_to": "PRG",
            "quality": 122.999795,
            "distance": 406.5,
            "duration": {
                "departure": 31500,
                "return": 0,
                "total": 31500
            },
            "price": 41,
            "conversion": {
                "EUR": 41
            },
            "bags_price": {
                "1": 64.47,
                "2": 128.94
            },
            "baglimit": {
                "hand_height": 40,
                "hand_length": 55,
                "hand_weight": 10,
                "hand_width": 20,
                "hold_dimensions_sum": 319,
                "hold_height": 119,
                "hold_length": 119,
                "hold_weight": 20,
                "hold_width": 81
            },
            "seats": 0,
            "route": [
                {
                    "id": "172925584a1a00006c014dd9_0",
                    "combination_id": "172925584a1a00006c014dd9",
                    "fly_from": "FRA",
                    "fly_to": "BGY",
                    "city_from": "Frankfurt",
                    "city_code_from": "FRA",
                    "city_to": "Milan",
                    "cityCodeTo": "MIL",
                    "airline": "FR",
                    "flight_no": 1688,
                    "operating_carrier": "FR",
                    "operating_flight_no": "1688",
                    "fare_basis": "",
                    "fare_category": "M",
                    "fare_classes": "",
                    "fare_family": "",
                    "return": 0,
                    "bags_recheck_required": false,
                    "guarantee": false,
                    "last_seen": "2021-06-21T13:25:31Z",
                    "refresh_timestamp": "2021-06-21T13:25:31Z",
                    "equipment": null,
                    "vehicle_type": "aircraft",
                    "local_arrival": "2021-12-09T14:40:00Z",
                    "utc_arrival": "2021-12-09T13:40:00Z",
                    "local_departure": "2021-12-09T13:20:00Z",
                    "utc_departure": "2021-12-09T12:20:00Z"
                },
            ],
            "booking_token": "BSj7h99a30f0Zr",
            "local_arrival": "2021-12-09T22:05:00Z",
            "utc_arrival": "2021-12-09T21:05:00Z",
            "local_departure": "2021-12-09T13:20:00Z",
            "utc_departure": "2021-12-09T12:20:00Z",
            "created_at": 1624345796,
            "updated_at": 1624345796
        },
*/

class Flight: Codable {
    var id: String
    var dateFrom: Date
    var dateTo: Date
    var cityFrom: City
    var cityTo: City
    var dateDeparture: Date
    var dateArrival: Date
    var duration: Int
    var price: Double
    var routeList: [RouteFlight] = []
    var token: String
    
    // MARK: - Initializers
    init?(json: JSON) {
        guard
            let id = json["id"] as? String,
            let tiFrom = json["date_from"] as? Double,
            let tiTo = json["date_to"] as? Double,
            let cityFromName = json["city_from"] as? String,
            let cityFromId = json["city_code_from"] as? String,
            let cityToName = json["city_to"] as? String,
            let cityToId = json["city_code_to"] as? String,
            let dateDepartureStr = json["local_departure"] as? String,
            let dateArrivalStr = json["local_arrival"] as? String,
            let dateDeparture = dateDepartureStr.toDate(dF5_yyyyMMddTHHmmssZ, 0),
            let dateArrival = dateArrivalStr.toDate(dF5_yyyyMMddTHHmmssZ, 0),
            let durationDict = json["duration"] as? [String: Any],
            let duration = durationDict["total"] as? Int,
            let price = json["price"] as? Double,
            let routeDictList = json["route"] as? [[String: Any]],
            let token = json["booking_token"] as? String
        else { return nil }
        
        self.id = id
        self.dateFrom = Date(timeIntervalSince1970: tiFrom)
        self.dateTo = Date(timeIntervalSince1970: tiTo)
        self.cityFrom = City(id: cityFromId, name: cityFromName)
        self.cityTo = City(id: cityToId, name: cityToName)
        self.dateDeparture = dateDeparture
        self.dateArrival = dateArrival
        self.duration = duration
        self.price = price
        self.routeList = RouteFlight.loadList(routeDictList)
        RouteFlight.adaptationList(self.routeList)
        
        self.token = token
    }
}

// MARK: - HelpersFuncs
extension Flight {
    var countStops: Int { return routeList.count }
}

/*
            "quality": 122.999795,
            "distance": 406.5,
            "duration": {
                "departure": 31500,
                "return": 0,
                "total": 31500
            },
            "price": 41,
            "conversion": {
                "EUR": 41
            },
            "bags_price": {
                "1": 64.47,
                "2": 128.94
            },
            "baglimit": {
                "hand_height": 40,
                "hand_length": 55,
                "hand_weight": 10,
                "hand_width": 20,
                "hold_dimensions_sum": 319,
                "hold_height": 119,
                "hold_length": 119,
                "hold_weight": 20,
                "hold_width": 81
            },
            "seats": 0,
            "route": [
                {
                    "id": "172925584a1a00006c014dd9_0",
                    "combination_id": "172925584a1a00006c014dd9",
                    "fly_from": "FRA",
                    "fly_to": "BGY",
                    "city_from": "Frankfurt",
                    "city_code_from": "FRA",
                    "city_to": "Milan",
                    "cityCodeTo": "MIL",
                    "airline": "FR",
                    "flight_no": 1688,
                    "operating_carrier": "FR",
                    "operating_flight_no": "1688",
                    "fare_basis": "",
                    "fare_category": "M",
                    "fare_classes": "",
                    "fare_family": "",
                    "return": 0,
                    "bags_recheck_required": false,
                    "guarantee": false,
                    "last_seen": "2021-06-21T13:25:31Z",
                    "refresh_timestamp": "2021-06-21T13:25:31Z",
                    "equipment": null,
                    "vehicle_type": "aircraft",
                    "local_arrival": "2021-12-09T14:40:00Z",
                    "utc_arrival": "2021-12-09T13:40:00Z",
                    "local_departure": "2021-12-09T13:20:00Z",
                    "utc_departure": "2021-12-09T12:20:00Z"
                },
            ],
            "booking_token": "BSj7h99a30f0Zr",
            "local_arrival": "2021-12-09T22:05:00Z",
            "utc_arrival": "2021-12-09T21:05:00Z",
            "local_departure": "2021-12-09T13:20:00Z",
            "utc_departure": "2021-12-09T12:20:00Z",
            "created_at": 1624345796,
            "updated_at": 1624345796
        },
*/

// MARK: - API
extension Flight {
    //func getDict() -> [String: Any]? { return self.values }
    static func loadList(_ dict: [[String: Any]]) -> [Flight] {
        var list: [Flight] = []
        dict.forEach { (json) in
            guard let item = Flight.init(json: json) else { return }
            list.append(item)
        }
        return list
    }
}
