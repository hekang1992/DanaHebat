//
//  OrderViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit
import SnapKit
import MJRefresh

class OrderViewController: BaseViewController {
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = languageCode == "id" ? UIImage(named: "olo_hea_image") : UIImage(named: "olo_ehea_image")
        return oneImageView
    }()
    
    lazy var orderView: OrderView = {
        let orderView = OrderView(frame: .zero)
        return orderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(appHeadView)
        appHeadView.configTitle(with: LanguageManager.localizedString(for: "Order Center"))
        appHeadView.backBtn.isHidden = true
        appHeadView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        view.addSubview(oneImageView)
        oneImageView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.size.equalTo(CGSize(width: 375.pix(), height: 123.pix()))
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(orderView)
        orderView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        orderView.tapClickBlock = { [weak self] type in
            ToastManager.showMessage(type)
        }
        
    }
    
}

