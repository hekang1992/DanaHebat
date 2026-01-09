//
//  LaunchViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit
import SnapKit
import FBSDKCoreKit

class LaunchViewController: BaseViewController {
    
    private let viewModel = HttpViewModel()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "launch_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkMonitor()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension LaunchViewController {
    
    func networkMonitor() {
        NetworkMonitor.shared.statusBlock = { [weak self] status in
            switch status {
            case .unknown:
                print("network=====unknown")
            case .notReachable:
                print("network=====notReachable")
            case .ethernetOrWiFi:
                NetworkMonitor.shared.stopListening()
                Task {
                    await self?.kgApi()
                }
                print("network=====WIFI")
            case .cellular:
                NetworkMonitor.shared.stopListening()
                Task {
                    await self?.kgApi()
                }
                print("network=====5G")
            }
            
        }
        
        NetworkMonitor.shared.startListening()
        
    }
    
}

extension LaunchViewController {
    
    private func kgApi() async {
        do {
            let kg = Locale.preferredLanguages.first ?? ""
            var parameters = DeviceNetworkInfo.getNetworkInfo()
            parameters["kg"] = kg
            let model = try await viewModel.launchApi(parameters: parameters)
            if model.illness == 0 {
                if let facebookModel = model.potions?.reports {
                    faceBookSDK(with: facebookModel)
                }
            }
        } catch {
            
        }
    }
    
    private func faceBookSDK(with model: reportsModel) {
        Settings.shared.displayName = model.baldness ?? ""
        Settings.shared.appURLSchemeSuffix = model.anecdotal ?? ""
        Settings.shared.appID = model.paralysis ?? ""
        Settings.shared.clientToken = model.treatment ?? ""
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            didFinishLaunchingWithOptions: nil
        )
    }
    
}
