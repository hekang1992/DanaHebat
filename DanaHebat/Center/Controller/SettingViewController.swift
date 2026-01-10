//
//  SettingViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit

class SettingViewController: BaseViewController {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "log_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo_mine_image")
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.text = "1.0.0"
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var oneListView: SettingListView = {
        let oneListView = SettingListView(frame: .zero)
        oneListView.logoImageView.image = UIImage(named: "del_mine_image")
        oneListView.nameLabel.text = LanguageManager.localizedString(for: "Account Cancellation")
        return oneListView
    }()
    
    lazy var twoListView: SettingListView = {
        let twoListView = SettingListView(frame: .zero)
        twoListView.logoImageView.image = UIImage(named: "ot_mine_image")
        twoListView.nameLabel.text = LanguageManager.localizedString(for: "Sign Out")
        return twoListView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(appHeadView)
        appHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        appHeadView.configTitle(with: LanguageManager.localizedString(for: "Settings"))
        
        appHeadView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgImageView).offset(42)
            make.size.equalTo(CGSize(width: 174.pix(), height: 118.pix()))
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(11.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(22.pix())
        }
        
        view.addSubview(oneListView)
        view.addSubview(twoListView)
        
        oneListView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(21.pix())
            make.size.equalTo(CGSize(width: 343.pix(), height: 64.pix()))
        }
        
        twoListView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneListView.snp.bottom).offset(12.pix())
            make.size.equalTo(CGSize(width: 343.pix(), height: 64.pix()))
        }
        
        oneListView.tapBlock = { [weak self] in
            guard let self = self else { return }
            self.goDelete()
        }
        
        twoListView.tapBlock = { [weak self] in
            guard let self = self else { return }
            self.popOut()
        }
        
    }
    
}

extension SettingViewController {
    
    private func goDelete() {
        let deleteVc = SureDeleteViewController()
        self.navigationController?.pushViewController(deleteVc, animated: true)
    }
    
    private func popOut() {
        
    }
    
}
