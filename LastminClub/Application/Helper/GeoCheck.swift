//
//  GeoCheck.swift
//  LastminClub
//
//  Created by Zorin Aleksandr on 09.04.2021.
//

import UIKit
import CoreLocation

// MARK: - Enum
enum ErrorGeo {
    case locationServicesEnabled
    case needAuthorizationStatusEnabled
    case restricted
    case denied
    case notDetermined
    case unknown
}
typealias AlertText = (title: String, subtitle: String)

// MARK: - GeoCheck
class GeoCheck {
    // MARK: Private Properties
    let vc: UIViewController
    
    // MARK: - Initializers
    init(_ vc: UIViewController) {
        self.vc = vc
    }  
}

// MARK: -
extension GeoCheck {
    public func isReadyGeo() -> Bool {
        /*Если в настройках отключены службы определения местоположения: Доступно=true*/
        guard CLLocationManager.locationServicesEnabled() else {
            ErrorGeo.locationServicesEnabled.showOfferToAcccessGeolocation(vc)
            return false
        }
        
        /*Проверяем статус авторизации*/
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse: return true
        case .authorizedAlways: return true
        case .restricted:
            let alertText = ErrorGeo.restricted.getAlertText()
            vc.displayAlert(alertText.title, alertText.subtitle)
            return false
        case .denied:
            ErrorGeo.denied.showOfferToAcccessGeolocation(vc)
            return false
        case .notDetermined:
            ErrorGeo.notDetermined.showOfferToAcccessGeolocation(vc)
            return false
        default:
            let alertText = ErrorGeo.unknown.getAlertText()
            vc.displayAlert(alertText.title, alertText.subtitle)
            return false
        }
    }
}

// MARK: - ErrorGeo
extension ErrorGeo {
    func getAlertText() -> AlertText {
        switch self {
        case .locationServicesEnabled:
            let title = "Службы геолокации отключены на устройстве"
            let subtitle = "Перейти к настройкам приложения, для включения доступа к службам геолокации?"
            //let subtitle = "Для определения Вашего местоположения нужно включить службы геолокации в настройках устройства."
            return AlertText(title, subtitle)
        case .needAuthorizationStatusEnabled:
            let title = "Отсутствует требуемый статус авторизации"
            let subtitle = ""
            return AlertText(title, subtitle)
        case .restricted:
            let title = "Сервисы геолокации недоступны."
            let subtitle = ""
            return AlertText(title, subtitle)
            //Locations are restricted
        case .denied:
            let title = "У приложения нет доступа к службам геолокации"
            let subtitle = "Перейти к настройкам приложения, для включения доступа к службам геолокации?"
            return AlertText(title, subtitle)
            //Locations are turned off. Please turn it on in Settings
        case .notDetermined: //Пользователь еще не сделал выбор в отношении этого приложения
            let title = "У приложения нет доступа к службам геолокации"
            let subtitle = "Перейти к настройкам приложения, для включения доступа к службам геолокации?"
            return AlertText(title, subtitle)
            // Locations are not determined yet
        case .unknown:
            let title = "Произошла какая-то неизвестная ошибка"
            let subtitle = ""
            return AlertText(title, subtitle)
            // Some Unknown Error occurred
        }
    }
    
    func showOfferToAcccessGeolocation(_ vc: UIViewController) {
        let alertText = self.getAlertText()
        vc.displayAlertYesNo(alertText.title, alertText.subtitle) { (isYes) in
            guard isYes else { return }
            if let url = URL(string: UIApplication.openSettingsURLString) {
                DispatchQueue.main.async { UIApplication.shared.open(url) }
            }
        }
    }
}
