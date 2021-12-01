//
//  Geo.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import CoreLocation

class Geo: Codable, Equatable {
    var lat: Double
    var lon: Double
    
    init(_ lat: Double, _ lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    init(clLC2D: CLLocationCoordinate2D) {
        self.lat = clLC2D.latitude
        self.lon = clLC2D.longitude
    }
    init(location: CLLocation) {
        self.lat = location.coordinate.latitude
        self.lon = location.coordinate.longitude
    }
    
    static func == (lhs: Geo, rhs: Geo) -> Bool {
            return (lhs.lat == rhs.lat) && (lhs.lon == rhs.lon)
        }
}

//extension Geo: Codable {
//    enum CodingKeys: String, CodingKey {
//        case lat, lon
//    }
//}

// MARK: - HelperFunctions
extension Geo {
    func toCLLC2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    func toCLLocation() -> CLLocation { return CLLocation(latitude: lat, longitude: lon) }
    func info() -> String { return "\(lat), \(lon)" }
}

// MARK: - CLLocation
extension CLLocation {
    static func toGeo(_ location: CLLocation?) -> Geo? {
        guard let location = location else { return nil }
        return Geo(clLC2D: location.coordinate)
    }
}
