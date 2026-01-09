//
//  LaunchViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit
import SnapKit

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
        ToastManager.showMessage("kgApi")
    }
    
}
