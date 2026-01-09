//
//  CommonParaManager.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit
import Foundation
import AdSupport

final class CommonParaManager {
    
    class func getDeviceInfo() -> [String: String] {
        var dict: [String: String] = [:]
        dict["turns"] = appVersion()
        dict["tight"] = deviceModel()
        dict["quick"] = DeviceIDManager.getIDFV()
        dict["capable"] = UIDevice.current.systemVersion
        dict["increased"] = ""
        dict["give"] = DeviceIDManager.getIDFA()
        dict["being"] = ""
        return dict
    }
}

private extension CommonParaManager {
    static func appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
}

private extension CommonParaManager {
    static func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = mirror.children.reduce("") { result, element in
            guard let value = element.value as? Int8, value != 0 else { return result }
            return result + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

final class RequestParamBuilder {
    
    class func buildRequestString(baseURL: String) -> String {
        
        let deviceInfo = CommonParaManager.getDeviceInfo()
        
        guard let jsonString = jsonString(from: deviceInfo) else {
            return baseURL
        }
        
        let encodedJSON = jsonString.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? ""
        
        if baseURL.contains("?") {
            return baseURL + "&data=" + encodedJSON
        } else {
            return baseURL + "?data=" + encodedJSON
        }
    }
}

private extension RequestParamBuilder {
    
    static func jsonString(from dict: [String: String]) -> String? {
        guard JSONSerialization.isValidJSONObject(dict) else {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(
                withJSONObject: dict,
                options: []
            )
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
