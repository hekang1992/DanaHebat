//
//  DeviceNetworkInfo.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import Foundation
import NetworkExtension
import SystemConfiguration

class DeviceNetworkInfo {
    
    static func isUsingVPN() -> Bool {
        let vpnProtocolsKeysIdentifiers = [
            "tap", "tun", "ppp", "ipsec", "utun", "ipsec0"
        ]
        
        guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
        let dict = cfDict.takeRetainedValue() as NSDictionary
        
        if let keys = dict["__SCOPED__"] as? NSDictionary {
            for key in keys.allKeys {
                if let keyString = key as? String {
                    for protocolId in vpnProtocolsKeysIdentifiers {
                        if keyString.contains(protocolId) {
                            return true
                        }
                    }
                }
            }
        }
        
        let interfaces = NEVPNManager.shared().connection
        if interfaces.status == .connected {
            return true
        }
        
        return false
    }
    
    static func isUsingHTTPProxy() -> Bool {
        guard let proxiesSettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? Dictionary<String, Any>,
              let scoped = proxiesSettings["__SCOPED__"] as? Dictionary<String, Any> else {
            return false
        }
        
        for (key, value) in scoped {
            if key.contains("en") || key.contains("pdp_ip") {
                if let dict = value as? Dictionary<String, Any> {
                    if let proxy = dict["HTTPProxy"] as? String, !proxy.isEmpty {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    static func getNetworkInfo() -> [String: String] {
        var result: [String: String] = [:]
        
        let hasProxy = isUsingHTTPProxy()
        result["company"] = hasProxy ? "1" : "0"
        
        let hasVPN = isUsingVPN()
        result["pharmaceutical"] = hasVPN ? "1" : "0"
        
        return result
    }
}
