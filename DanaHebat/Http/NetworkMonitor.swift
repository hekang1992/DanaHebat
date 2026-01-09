//
//  NetworkMonitor.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import Alamofire

enum NetworkStatus {
    case unknown
    case notReachable
    case ethernetOrWiFi
    case cellular
}

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private init() {}
    
    private var isListening = false
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    var statusBlock: ((NetworkStatus) -> Void)?
    
    func startListening() {
        guard !isListening else { return }
        isListening = true
        
        reachabilityManager?.startListening { [weak self] status in
            guard let self = self else { return }
            
            let networkStatus: NetworkStatus
            
            switch status {
            case .unknown:
                networkStatus = .unknown
            case .notReachable:
                networkStatus = .notReachable
            case .reachable(let connectionType):
                switch connectionType {
                case .ethernetOrWiFi:
                    networkStatus = .ethernetOrWiFi
                case .cellular:
                    networkStatus = .cellular
                }
            }
            self.statusBlock?(networkStatus)
        }
    }
    
    func stopListening() {
        guard isListening else { return }
        isListening = false
        
        reachabilityManager?.stopListening()
    }
}
