//
//  MapKitHelper.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import MapKit

class MapKitHelper {}

// MARK: -
extension MapKitHelper {
    static func geocoder(_ geo: Geo, onResult: @escaping (Result<String, ErrorApp>)->()) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(geo.toCLLocation()) { (placemarks, error) in
            if let error = error { onResult(.failure(.custom(error.localizedDescription))); return }
            let placemark = placemarks?[0]
            print(placemark?.isoCountryCode, placemark?.country)
            guard let country = placemark?.country
            else { onResult(.failure(.custom("Не удалось определить страну вашего месторасположения"))); return }
            onResult(.success(country))
        }
        
    }
//    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
//                    -> Void ) {
//        // Use the last reported location.
//        if let lastLocation = self.locationManager.location {
//            let geocoder = CLGeocoder()
//
//            // Look up the location and pass it to the completion handler
//            geocoder.reverseGeocodeLocation(lastLocation,
//                        completionHandler: { (placemarks, error) in
//                if error == nil {
//                    let firstLocation = placemarks?[0]
//                    completionHandler(firstLocation)
//                }
//                else {
//                 // An error occurred during geocoding.
//                    completionHandler(nil)
//                }
//            })
//        }
//        else {
//            // No location was available.
//            completionHandler(nil)
//        }
//    }
}
