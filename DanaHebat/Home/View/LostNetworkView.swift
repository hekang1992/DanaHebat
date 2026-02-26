//
//  LostNetworkView.swift
//  DanaHebat
//
//  Created by Json Kim on 2026/1/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LostNetworkView: UIView {
    
    private let disposeBag = DisposeBag()
    
    var againBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "log_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "lost_net_image")
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.text = LanguageManager.localizedString(for: "The network is broken.\nPlease hold on.")
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return nameLabel
    }()
    
    lazy var tryBtn: UIButton = {
        let tryBtn = UIButton(type: .custom)
        tryBtn.setBackgroundImage(UIImage(named: "aly_a_im_age"), for: .normal)
        tryBtn.setTitle(LanguageManager.localizedString(for: "Try Again"), for: .normal)
        tryBtn.setTitleColor(UIColor.init(hexString: "#333333"), for: .normal)
        tryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return tryBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(logoImageView)
        addSubview(nameLabel)
        addSubview(tryBtn)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100.pix())
            make.size.equalTo(CGSize(width: 225.pix(), height: 173.pix()))
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(15.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 190.pix(), height: 45.pix()))
        }
        tryBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5.pix())
            make.size.equalTo(CGSize(width: 130.pix(), height: 34.pix()))
        }
        
        tryBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.againBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
