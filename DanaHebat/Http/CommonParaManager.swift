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
    
    static func buildRequestString(from baseURL: String) -> String {
        let deviceInfo = CommonParaManager.getDeviceInfo()
        return baseURL.addParameters(deviceInfo)
    }
}

extension String {
    
    func addParameters(_ parameters: [String: Any]) -> String {
        guard let url = URL(string: self),
              let urlWithParams = url.addParameters(parameters) else {
            return ""
        }
        return urlWithParams.absoluteString
    }
}

extension URL {
    
    func addParameters(_ parameters: [String: Any]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        let queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        components.queryItems = (components.queryItems ?? []) + queryItems
        return components.url
    }
}
