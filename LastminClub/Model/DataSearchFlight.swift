//
//  DataSearchFlight.swift
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

class DataSearchFlight: Codable {
    var dateFrom: Date?
    var dateTo: Date?
    var cityFrom: City?
    var cityTo: City?
    
    init() {}
}

// MARK: - HelpersFuncs
extension DataSearchFlight {
    func pathFilter() -> String {
        //https://apitest.fun:9595/api/v1/flights/search?fly_from=FRA&fly_to=PRG&date_from=09%2F12%2F2021&date_to=10%2F12%2F2021&limit=12

        var res: String = ""
        if let date = dateFrom {
            res += res.isEmpty ? "?" : "&"
            res += "date_from=\(date.toString(df1_ddMMyyyy))"
        }
        if let date = dateTo {
            res += res.isEmpty ? "?" : "&"
            res += "date_to=\(date.toString(df1_ddMMyyyy))"
        }
        if let city = cityFrom {
            res += res.isEmpty ? "?" : "&"
            res += "fly_from=\(city.id)"
        }
        if let city = cityTo {
            res += res.isEmpty ? "?" : "&"
            res += "fly_to=\(city.id)"
        }
        // limit
        res += res.isEmpty ? "?" : "&"
        res += "limit=10"
        
        return res
    }
}
