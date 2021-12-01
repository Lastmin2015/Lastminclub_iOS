//
//  GEOService.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import UIKit
import CoreLocation

//protocol GEOServiceDelegate: class {
//    func authorizationDenied()
//    func setMapRegion(center: CLLocation)
//    //func getCheckPoint(_ checkPoint: RacePoint )
//}


let geoService = GEOService.shared

final class GEOService: NSObject {
    // MARK: Constant
    static let shared = GEOService()
    // MARK: Private Properties
    public let locationManager = CLLocationManager()
    public var lastLocation: CLLocation?
    // MARK: Public Properties
    var isMonitor: Bool = false
    //weak var delegate: GEOServiceDelegate?
    var didUpdateGEO: ((Geo) -> Void)?
    var didAuthorized: (()->Void)?
    var didInfoGEO: ((String) -> Void)?
    
    // MARK: - Initializers
    override init() {
        super.init()
        configurate()
    }
    deinit { destroyLocationManager() }
    
    private func configurate() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    private func destroyLocationManager() {
        locationManager.delegate = nil
        lastLocation = nil
    }
}

//MARK: - Public Methods
extension GEOService {
    func getCurrentLocation(block: ( (Geo) -> Void)? ) {
        guard isReadyService() else { return }
        didUpdateGEO = block
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        guard isReadyService() else { return }
        isMonitor = true
        lastLocation = nil
        locationManager.startUpdatingLocation()
    }
    func stopUpdatingLocation() {
        isMonitor = false
        locationManager.stopUpdatingLocation()
        lastLocation = nil
    }
}

// MARK: - CLLocationManagerDelegate
extension GEOService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isMonitor { locationManager.stopUpdatingLocation() }
        
        guard let newLocation = locations.last else { return }
        //guard isGoodNewLocation(newLocation) else { return }
        lastLocation = newLocation
        didUpdateGEO?(Geo(location: newLocation))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStatus(status)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - HelpersFunc
extension GEOService {
}

// MARK: - проверка доступа
extension GEOService {
    /*Если в настройках отключены службы определения местоположения: Доступно=true*/
    func isLocationEnabled() -> Bool { return CLLocationManager.locationServicesEnabled() }
    func isReadyService() -> Bool {
        guard isLocationEnabled() else { return false}
        let status = CLLocationManager.authorizationStatus()
        guard (status == .authorizedWhenInUse) || (status == .authorizedAlways)
        else { print("😈 Пользователь не дал доступа к локации"); return false }
        
        return true
    }
    //
    private func checkAuthorizationStatus(_ status: CLAuthorizationStatus) {
        // let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined: locationManager.requestLocation() //locationManager.requestAlwaysAuthorization()// было
        case .denied: ()//delegate?.authorizationDenied()
        case .authorizedAlways, .authorizedWhenInUse: didAuthorized?()
//            getCurrentLocation { (checkPoint) in
//                ()
//                //self.didUpdateGEO?(checkPoint)
//            }
            //startUpdatingLocation()
        default: break
        }
    }
}
