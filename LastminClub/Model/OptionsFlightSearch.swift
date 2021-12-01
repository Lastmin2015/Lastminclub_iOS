//
//  OptionsFlightSearch.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 30.04.2021.
//

import Foundation

class OptionsFlightSearch: Codable {
    var isAddNearbyAirports: Bool = true
    var typeSearch: Int = 1 //1, 2, 3
    var countBaggageChecked: Int = 0
    var countBaggageCabin: Int = 0
    var routeMaximumDuration: Int = 0
    var routeMaximumStop: Int = 0
    var excludeCountriesList: [String] = ["UK", "Ukraine", "Russia"]//[]
}

// MARK: - HelpersFunctions
extension OptionsFlightSearch {
    func excludeCountriesStr() -> String {
        guard let item = excludeCountriesList.first else { return "" }
        let count = excludeCountriesList.count - 1
        return "\(item)" + "\((count > 0) ? " +\(count)" : "")"
    }
}

// MARK: - Save/Load Loacally
extension OptionsFlightSearch {
    func saveLastLocally() { LocallyData.save_klastOptionsFlightSearch(self) }
    static func loadLastLocally() -> OptionsFlightSearch? {
        return LocallyData.load_klastOptionsFlightSearch()
    }
}
