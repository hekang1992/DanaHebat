//
//  BaseViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit

class BaseViewController: UIViewController {
    
    lazy var appHeadView: AppNavView = {
        let appHeadView = AppNavView(frame: .zero)
        return appHeadView
    }()
    
    let languageCode = LanguageManager.shared.getCurrentLocaleCode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
}

extension BaseViewController {
    
    func changeRootVc() {
        let tabBarVc = BaseTabBarController()
        if let window = UIApplication.shared.windows.first {
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: {
                window.rootViewController = tabBarVc
            }, completion: nil)
        }
    }
    
    func backProductVc() {
        guard let nav = navigationController,
              let productVC = nav.viewControllers.first(where: { $0 is ProductViewController })
        else {
            navigationController?.popToRootViewController(animated: true)
            return
        }
        nav.popToViewController(productVC, animated: true)
    }
    
    func goWordWebVc(with pageUrl: String) {
        let webVc = WordH5WebViewController()
        webVc.pageUrl = pageUrl
        self.navigationController?.pushViewController(webVc, animated: true)
    }
    
}
