//
//  LaunchViewController.swift
//  DanaHebat
//
//  Created by Json Kim on 2026/1/9.
//

import UIKit
import SnapKit
import FBSDKCoreKit
import IQKeyboardManagerSwift

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
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
}

extension LaunchViewController {
    
    func networkMonitor() {
        NetworkMonitor.shared.statusBlock = { [weak self] status in
            switch status {
            case .unknown:
                break
            case .notReachable:
                print("============notReachable")
                if UIDevice.current.model == "iPad" {
                    LanguageManager.shared.setLanguage(code: 1)
                    self?.changeRootVc()
                }
                
            case .ethernetOrWiFi, .cellular:
                NetworkMonitor.shared.stopListening()
                Task {
                    await self?.urlInfo()
                }
                
            }
            
        }
        
        NetworkMonitor.shared.startListening()
        
    }
    
}

extension LaunchViewController {
    
    private func urlInfo() async {
        do {
            let urlString = "https://id08-dc.oss-ap-southeast-5.aliyuncs.com/dana-hebat/dh.json"
            let items = try await fetchJSON(from: urlString)
            
            let savedIndex = UserDefaults.standard.integer(forKey: "domainIndex")
            
            if await testDomain("https://dh.ate-tech.com") {
                UserDefaults.standard.set("https://dh.ate-tech.com/seropositiveer", forKey: "API_URL")
                await kgApi()
            }else {
                for i in savedIndex..<items.count {
                    if await testDomain(items[i].dh) {
                        UserDefaults.standard.set(i, forKey: "domainIndex")
                        UserDefaults.standard.set(items[i].dh, forKey: "API_URL")
                        await kgApi()
                        return
                    }
                }
            }
        } catch {
            
        }
        
    }
    
    private func testDomain(_ domain: String) async -> Bool {
        guard let url = URL(string: domain) else { return false }
        
        do {
            var request = URLRequest(url: url)
            request.timeoutInterval = 10
            request.httpMethod = "HEAD"
            
            let (_, response) = try await URLSession.shared.data(for: request)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }
    
    private func kgApi() async {
        do {
            let kg = Locale.preferredLanguages.first ?? ""
            var parameters = DeviceNetworkInfo.getNetworkInfo()
            parameters["kg"] = kg
            let model = try await viewModel.launchApi(parameters: parameters)
            
            if model.illness == 0 {
                if UIDevice.current.model == "iPad" {
                    LanguageManager.shared.setLanguage(code: 1)
                }else {
                    let being = Int(model.potions?.being ?? "1") ?? 1
                    LanguageManager.shared.setLanguage(code: being)
                }
                
                if let facebookModel = model.potions?.reports {
                    faceBookSDK(with: facebookModel)
                }
                
                checkAndNavigateToGuideOrHome()
            }
            
        } catch {
            
        }
    }
    
    private func checkAndNavigateToGuideOrHome() {
        let guideStatus = SaveGuideShowManager.checkIfGuideShown()
        
        DispatchQueue.main.async {
            if guideStatus == "0" {
                self.navigateToGuidePage()
            } else {
                self.changeRootVc()
            }
        }
    }
    
    private func navigateToGuidePage() {
        let guideVC = GuideViewController()
        
        if let window = UIApplication.shared.windows.first {
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: {
                window.rootViewController = guideVC
            }, completion: nil)
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

