//
//  DeepLinkRoute.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//


import UIKit

struct DeepLinkRoute {
    let path: String
    let queryParams: [String: String]
    static let scheme_url = "ios://Dan.aHe.bat"
    
    init?(url: URL) {
        guard url.scheme == "ios",
              url.host == "Dan.aHe.bat" else {
            return nil
        }
        
        self.path = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        
        var params: [String: String] = [:]
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            for item in queryItems {
                params[item.name] = item.value
            }
        }
        self.queryParams = params
    }
}

class URLSchemeRouter: NSObject {
    
    static func handle(pageURL: String, from vc: BaseViewController) {
        guard let url = URL(string: pageURL) else {
            return
        }
        
        guard let route = DeepLinkRoute(url: url) else {
            return
        }
        
        switch route.path {
            
        case "scientific":
            let settingVc = SettingViewController()
            vc.navigationController?.pushViewController(settingVc, animated: true)
            
        case "of":
            break
            
        case "aphive":
            break
            
        case "described":
            break
            
        case "are":
            break
            
        case "clades":
//            let productVc = ProductViewController()
//            let queryParams = route.queryParams
//            productVc.productID = queryParams["seget"] ?? ""
//            vc.navigationController?.pushViewController(productVc, animated: true)
            break
            
        default:
            break
        }
    }
}
