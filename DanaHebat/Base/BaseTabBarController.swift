//
//  BaseTabBarController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let orderVC = OrderViewController()
        let mineVC = MineViewController()
        
        homeVC.tabBarItem = UITabBarItem(
            title: LanguageManager.localizedString(for: "Home"),
            image: UIImage(named: "home_nor_sel_image")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "home_tab_sel_image")?.withRenderingMode(.alwaysOriginal)
        )
        
        orderVC.tabBarItem = UITabBarItem(
            title: LanguageManager.localizedString(for: "Order"),
            image: UIImage(named: "order_nor_sel_image")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "order_tab_sel_image")?.withRenderingMode(.alwaysOriginal)
        )
        
        mineVC.tabBarItem = UITabBarItem(
            title: LanguageManager.localizedString(for: "Mine"),
            image: UIImage(named: "cn_nor_sel_image")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "cn_tab_sel_image")?.withRenderingMode(.alwaysOriginal)
        )
        
        self.viewControllers = [
            BaseNavigationController(rootViewController: homeVC),
            BaseNavigationController(rootViewController: orderVC),
            BaseNavigationController(rootViewController: mineVC)
        ]
    }
    
    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        
        tabBarAppearance.configureWithDefaultBackground()
        
        self.tabBar.standardAppearance = tabBarAppearance
        
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
    
}

