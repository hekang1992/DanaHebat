//
//  DeviceIDManager.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit
import AdSupport
import Security
import AppTrackingTransparency

final class DeviceIDManager {
    
    class func getIDFA() -> String {
        let manager = ASIdentifierManager.shared()
        
        let idfa = manager.advertisingIdentifier.uuidString
        
        if idfa == "00000000-0000-0000-0000-000000000000" {
            return ""
        }
        
        return idfa
    }
    
    class func getIDFV() -> String {
        let key = "com.DanaPundi.device.idfv"
        
        if let idfv = KeychainHelper.load(key: key) {
            return idfv
        }
        
        let idfv = UIDevice.current.identifierForVendor?.uuidString
        ?? UUID().uuidString
        
        KeychainHelper.saveIfNeeded(key: key, value: idfv)
        
        return idfv
    }
}
