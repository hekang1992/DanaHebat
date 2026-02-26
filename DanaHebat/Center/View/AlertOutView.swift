//
//  AlertOutView.swift
//  DanaHebat
//
//  Created by Json Kim on 2026/1/11.
//


import UIKit
import SnapKit
import RxCocoa
import RxSwift

class AlertOutView: UIView {
    
    private let disposeBag = DisposeBag()
    
    var leftBlock: (() -> Void)?
    
    var rightBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = LanguageManager.shared.getCurrentLocaleCode() == "id" ? UIImage(named: "logd_out_image") : UIImage(named: "log_out_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton(type: .custom)
        return leftBtn
    }()
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton(type: .custom)
        return rightBtn
    }()
    
//    UserDefaults.standard.set(money, forKey: "money")
//    UserDefaults.standard.set(rate, forKey: "rate")
//    UserDefaults.standard.synchronize()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .center
        let money = UserDefaults.standard.object(forKey: "money") as? String ?? ""
        moneyLabel.text = money.isEmpty ? "9.900.000" : money
        moneyLabel.textColor = UIColor.init(hexString: "#333333")
        moneyLabel.font = UIFont.systemFont(ofSize: 45, weight: UIFont.Weight(900))
        return moneyLabel
    }()
    
    lazy var rateLabel: UILabel = {
        let rateLabel = UILabel()
        rateLabel.textAlignment = .center
        let rate = UserDefaults.standard.object(forKey: "rate") as? String ?? ""
        rateLabel.text = rate.isEmpty ? LanguageManager.localizedString(for: "0.04%/Day") : "\(rate)/\(LanguageManager.localizedString(for: "Day"))"
        rateLabel.textColor = UIColor.init(hexString: "#0329F6")
        rateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return rateLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(leftBtn)
        bgImageView.addSubview(rightBtn)
        bgImageView.addSubview(moneyLabel)
        bgImageView.addSubview(rateLabel)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 325.pix(), height: 355.pix()))
        }
        leftBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 157.pix(), height: 60.pix()))
        }
        rightBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 157.pix(), height: 60.pix()))
        }
        moneyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(46.pix())
            if LanguageManager.shared.getCurrentLocaleCode() == "id" {
                make.top.equalToSuperview().offset(175.pix())
            }else {
                make.top.equalToSuperview().offset(165.pix())
            }
        }
        rateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(moneyLabel.snp.bottom).offset(25.pix())
            make.height.equalTo(25.pix())
        }
        
        leftBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.leftBlock?()
            })
            .disposed(by: disposeBag)
        
        rightBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.rightBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
