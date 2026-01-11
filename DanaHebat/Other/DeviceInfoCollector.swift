//
//  DeviceInfoCollector.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import Foundation
import SystemConfiguration
import CoreTelephony
import UIKit
import NetworkExtension

class DeviceInfoCollector {
    
    struct DeviceInfo: Codable {
        let japan: JapanInfo
        let palearctic: BatteryInfo
        let paleotropical: SystemInfo
        let cestodes: SecurityInfo
        let lecithodendrium: DeviceIdentifiers
        var affected: WifiInfo?
        
        struct JapanInfo: Codable {
            let north: String
            let across: String
            let occurring: String
            let greatest: String
        }
        
        struct BatteryInfo: Codable {
            let southern: Int
            let distribution: Int
        }
        
        struct SystemInfo: Codable {
            let habitat: String
            let range: String
            let potorolepsis: String
        }
        
        struct SecurityInfo: Codable {
            let prosthodendrium: Int
            let plagiorchis: Int
        }
        
        struct DeviceIdentifiers: Codable {
            let trematodes: String
            let forested: String
            let kg: String
            let endoparasites: String
            let occur: String
        }
        
        struct WifiInfo: Codable {
            let rhinolophopsylla: WifiDetail?
            
            struct WifiDetail: Codable {
                let fleas: String
                let crawl: String
            }
        }
    }
    
    private let networkMonitor = NWPathMonitor()
    private var currentNetworkType: String = "OTHER"
    
    func collectDeviceInfo(completion: @escaping (DeviceInfo) -> Void) {
        let deviceInfo = DeviceInfo(
            japan: getStorageAndMemoryInfo(),
            palearctic: getBatteryInfo(),
            paleotropical: getSystemInfo(),
            cestodes: getSecurityInfo(),
            lecithodendrium: getDeviceIdentifiers(),
            affected: nil
        )
        
        fetchWifiInfo { wifiInfo in
            var updatedInfo = deviceInfo
            updatedInfo.affected = wifiInfo
            completion(updatedInfo)
        }
    }
    
    private func getStorageAndMemoryInfo() -> DeviceInfo.JapanInfo {
        var totalSpace: UInt64 = 0
        var freeSpace: UInt64 = 0
        
        do {
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            totalSpace = (systemAttributes[.systemSize] as? NSNumber)?.uint64Value ?? 0
            freeSpace = (systemAttributes[.systemFreeSize] as? NSNumber)?.uint64Value ?? 0
        } catch {
            if let url = URL(string: NSHomeDirectory()) {
                do {
                    let values = try url.resourceValues(forKeys: [.volumeTotalCapacityKey, .volumeAvailableCapacityForImportantUsageKey])
                    totalSpace = UInt64(values.volumeTotalCapacity ?? 0)
                    freeSpace = UInt64(values.volumeAvailableCapacityForImportantUsage ?? 0)
                } catch {
                    
                }
            }
        }
        
        var totalMemory: UInt64 = 0
        var freeMemory: UInt64 = 0
        
        totalMemory = ProcessInfo.processInfo.physicalMemory
        
        var hostSize = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)
        var hostInfo = vm_statistics_data_t()
        let hostPort = mach_host_self()
        
        let kernReturn = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(hostSize)) {
                host_statistics(hostPort, HOST_VM_INFO, $0, &hostSize)
            }
        }
        
        if kernReturn == KERN_SUCCESS {
            let pageSize = vm_kernel_page_size
            let freeMem = UInt64(hostInfo.free_count) * UInt64(pageSize)
            let inactiveMem = UInt64(hostInfo.inactive_count) * UInt64(pageSize)
            freeMemory = freeMem + inactiveMem
        } else {
            var taskInfo = task_vm_info_data_t()
            var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
            let kr = withUnsafeMutablePointer(to: &taskInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                    task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
                }
            }
            if kr == KERN_SUCCESS {
                let used = UInt64(taskInfo.phys_footprint)
                freeMemory = totalMemory > used ? totalMemory - used : 0
            }
        }
        
        return DeviceInfo.JapanInfo(
            north: "\(freeSpace)",
            across: "\(totalSpace)",
            occurring: "\(totalMemory)",
            greatest: "\(freeMemory)"
        )
    }
    
    private func getBatteryInfo() -> DeviceInfo.BatteryInfo {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        let isCharging: Int = {
            switch UIDevice.current.batteryState {
            case .charging, .full:
                return 1
            default:
                return 0
            }
        }()
        
        UIDevice.current.isBatteryMonitoringEnabled = false
        
        return DeviceInfo.BatteryInfo(
            southern: batteryLevel,
            distribution: isCharging
        )
    }
    
    private func getSystemInfo() -> DeviceInfo.SystemInfo {
        return DeviceInfo.SystemInfo(
            habitat: UIDevice.current.systemVersion,
            range: UIDevice.current.name,
            potorolepsis: getDeviceModel()
        )
    }
    
    private func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    
    private func getSecurityInfo() -> DeviceInfo.SecurityInfo {
#if targetEnvironment(simulator)
        let isSimulator = 1
#else
        let isSimulator = 0
#endif
        
        let isJailbroken = checkJailbreak() ? 1 : 0
        
        return DeviceInfo.SecurityInfo(
            prosthodendrium: isSimulator,
            plagiorchis: isJailbroken
        )
    }
    
    private func checkJailbreak() -> Bool {
        let jailbreakPaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/"
        ]
        
        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        let testPath = "/private/jailbreak.txt"
        do {
            try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            return false
        }
    }
    
    private func getDeviceIdentifiers() -> DeviceInfo.DeviceIdentifiers {
        let timezone = TimeZone.current
        let timezoneID = timezone.abbreviation() ?? ""
        
        let idfv = DeviceIDManager.getIDFV()
        
        let language = Locale.preferredLanguages.first ?? "en"
        
        let networkType = getCurrentNetworkType()
        
        let idfa = getAdvertisingIdentifier()
        
        return DeviceInfo.DeviceIdentifiers(
            trematodes: timezoneID,
            forested: idfv,
            kg: language,
            endoparasites: networkType,
            occur: idfa
        )
    }
    
    private func getAdvertisingIdentifier() -> String {
        return DeviceIDManager.getIDFA()
    }
    
    private func getCurrentNetworkType() -> String {
        var networkType = "OTHER"
        
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com") else {
            return networkType
        }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        if flags.contains(.isWWAN) {
            let networkInfo = CTTelephonyNetworkInfo()
            let carrierType = networkInfo.serviceCurrentRadioAccessTechnology?.first?.value
            
            switch carrierType {
            case CTRadioAccessTechnologyGPRS,
                CTRadioAccessTechnologyEdge,
            CTRadioAccessTechnologyCDMA1x:
                networkType = "2G"
            case CTRadioAccessTechnologyWCDMA,
                CTRadioAccessTechnologyHSDPA,
                CTRadioAccessTechnologyHSUPA,
                CTRadioAccessTechnologyCDMAEVDORev0,
                CTRadioAccessTechnologyCDMAEVDORevA,
                CTRadioAccessTechnologyCDMAEVDORevB,
            CTRadioAccessTechnologyeHRPD:
                networkType = "3G"
            case CTRadioAccessTechnologyLTE:
                networkType = "4G"
            default:
                if #available(iOS 14.1, *) {
                    if carrierType == CTRadioAccessTechnologyNR || carrierType == CTRadioAccessTechnologyNRNSA {
                        networkType = "5G"
                    } else {
                        networkType = "OTHER"
                    }
                } else {
                    networkType = "OTHER"
                }
            }
        } else if flags.contains(.reachable) {
            networkType = "WIFI"
        }
        
        return networkType
    }
    
    private func fetchWifiInfo(completion: @escaping (DeviceInfo.WifiInfo?) -> Void) {
        if #available(iOS 14.0, *) {
            NEHotspotNetwork.fetchCurrent { hotspotNetwork in
                guard let network = hotspotNetwork else {
                    completion(nil)
                    return
                }
                
                let wifiDetail = DeviceInfo.WifiInfo.WifiDetail(
                    fleas: network.bssid,
                    crawl: network.ssid
                )
                
                let wifiInfo = DeviceInfo.WifiInfo(
                    rhinolophopsylla: wifiDetail
                )
                
                completion(wifiInfo)
            }
        }
    }
    
    func getDeviceInfoJSON(completion: @escaping (String?) -> Void) {
        collectDeviceInfo { deviceInfo in
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try encoder.encode(deviceInfo)
                let jsonString = String(data: jsonData, encoding: .utf8)
                completion(jsonString)
            } catch {
                print("JSON====: \(error)")
                completion(nil)
            }
        }
    }
}
