//
//  LocationInfo.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import UIKit
import Foundation
import CoreLocation

class SimpleLocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private static let lastAlertDateKey = "LastLocationAlertDate"
    private var completion: (([String: String]) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func getLocation(completion: @escaping ([String: String]) -> Void) {
        self.completion = completion
        
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            
        case .denied, .restricted:
            handlePermissionDenied()
            completion([:])
            
        @unknown default:
            completion([:])
        }
    }
}

extension SimpleLocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else if status == .denied || status == .restricted {
            handlePermissionDenied()
            completion?([:])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?([:])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let lat = String(location.coordinate.latitude)
        let lon = String(location.coordinate.longitude)
        SaceLocationMessageManager.saveLocation(lat, lon: lon)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self = self,
                  let placemark = placemarks?.first else {
                self?.completion?([:])
                return
            }
            
            let info = [
                "sarsr": placemark.administrativeArea ?? "",
                "number": placemark.isoCountryCode ?? "",
                "covid": placemark.country ?? "",
                "investigations": placemark.thoroughfare ?? "",
                "ambient": String(format: "%.6f", location.coordinate.latitude),
                "hibernate": String(format: "%.6f", location.coordinate.longitude),
                "for": placemark.locality ?? "",
                "unforested": placemark.subLocality ?? ""
            ]
            
            self.completion?(info)
        }
    }
}


extension SimpleLocationManager {
    
    private func handlePermissionDenied() {
        if LanguageManager.shared.getCurrentLocaleCode() == "id" {
            showPermissionAlertIfNeeded()
        }
    }
    
    private func showPermissionAlertIfNeeded() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: Date())
        
        let lastAlertDate = UserDefaults.standard.string(forKey: Self.lastAlertDateKey)
        guard lastAlertDate != todayString else { return }
        
        UserDefaults.standard.set(todayString, forKey: Self.lastAlertDateKey)
        
        DispatchQueue.main.async {
            guard
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = scene.windows.first,
                let rootVC = window.rootViewController
            else { return }
            
            let alert = UIAlertController(
                title: LanguageManager.localizedString(for: "Permission Required"),
                message: LanguageManager.localizedString(for: "Location permission is disabled. Please enable it in Settings to allow your loan application to be processed."),
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: LanguageManager.localizedString(for: "Cancel"), style: .cancel))
            
            alert.addAction(UIAlertAction(title: LanguageManager.localizedString(for: "Go to  settings"), style: .default) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            })
            
            rootVC.present(alert, animated: true)
        }
    }
    
}

class SaceLocationMessageManager {
    
    static func saveLocation(_ lat: String, lon: String) {
        UserDefaults.standard.set(lat, forKey: "lat")
        UserDefaults.standard.set(lon, forKey: "lon")
        UserDefaults.standard.synchronize()
    }
    
    static func getLatitude() -> String {
        return UserDefaults.standard.string(forKey: "lat") ?? ""
    }
    
    static func getLongitude() -> String {
        return UserDefaults.standard.string(forKey: "lon") ?? ""
    }
    
}
