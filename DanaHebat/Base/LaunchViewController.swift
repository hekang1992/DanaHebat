//
//  LaunchViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit
import SnapKit

class LaunchViewController: BaseViewController {
    
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
        NetworkMonitor.shared.statusBlock = { status in
            switch status {
            case .unknown:
                print("network=====unknown")
            case .notReachable:
                print("network=====notReachable")
            case .ethernetOrWiFi:
                NetworkMonitor.shared.stopListening()
                print("network=====WIFI")
            case .cellular:
                NetworkMonitor.shared.stopListening()
                print("network=====5G")
            }
            
        }
        
        NetworkMonitor.shared.startListening()
        
    }
    
}
