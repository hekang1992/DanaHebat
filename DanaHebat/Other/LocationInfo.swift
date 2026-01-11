//
//  LocationInfo.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import Foundation
import CoreLocation
import UIKit

final class SimpleLocationManager: NSObject {
    
    typealias LocationCompletion = ([String: String]?, String?) -> Void
    
    private let locationManager = CLLocationManager()
    
    private var completion: LocationCompletion?
    
    private static let lastAlertDateKey = "LastLocationAlertDate"
    
    let languageCode = LanguageManager.shared.getCurrentLocaleCode()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getLocation(completion: @escaping LocationCompletion) {
        self.completion = completion
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocationIfNeeded()
            
        case .denied, .restricted:
            handlePermissionDenied()
            
        @unknown default:
            completion(nil, "unknown authorization status")
        }
    }
    
    private func requestLocationIfNeeded() {
        locationManager.requestLocation()
    }
    
    private func handleLocation(_ location: CLLocation) {
        locationManager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            defer {
                self.completion = nil
            }
            
            guard let placemark = placemarks?.first else {
                self.completion?(nil, "reverse geocode failed")
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
            
            self.completion?(info, nil)
        }
    }
    
    private func handlePermissionDenied() {
        if languageCode == "id" {
            showPermissionAlertIfNeeded()
        }
        completion?(nil, "location permission denied")
    }
}

// MARK: - CLLocationManagerDelegate

extension SimpleLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        handleLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil, error.localizedDescription)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocationIfNeeded()
            
        case .denied, .restricted:
            handlePermissionDenied()
            
        default:
            break
        }
    }
}

extension SimpleLocationManager {
    
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
                title: "定位权限被禁用",
                message: "请在设置中开启定位权限以使用位置功能",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            
            rootVC.present(alert, animated: true)
        }
    }
}

