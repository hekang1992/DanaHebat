//
//  LoginView.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginView: UIView {
    
    private let disposeBag = DisposeBag()
    
    var loginBlock: (() -> Void)?
    
    var codeBlock: ((String) -> Void)?
    
    let languageCode = LanguageManager.shared.getCurrentLocaleCode()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "log_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = languageCode == "id" ? UIImage(named: "h_id_image") : UIImage(named: "w_en_image")
        oneImageView.contentMode = .scaleAspectFit
        return oneImageView
    }()
    
    lazy var goldImageView: UIImageView = {
        let goldImageView = UIImageView()
        goldImageView.image = UIImage(named: "go_ld_image")
        return goldImageView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 15
        whiteView.layer.masksToBounds = true
        return whiteView
    }()
    
    lazy var oneListView: LoginListView = {
        let oneListView = LoginListView()
        oneListView.iconImageView.image = UIImage(named: "log_p_image")
        oneListView.nameLabel.text = LanguageManager.localizedString(for: "Mobile Number")
        return oneListView
    }()
    
    lazy var phoneView: UIView = {
        let phoneView = UIView()
        phoneView.backgroundColor = UIColor.init(hexString: "#C0FFEC")
        phoneView.layer.cornerRadius = 10
        phoneView.layer.masksToBounds = true
        return phoneView
    }()
    
    lazy var phoneFiled: UITextField = {
        let phoneFiled = UITextField()
        phoneFiled.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: LanguageManager.localizedString(for: "Enter mobile number"), attributes: [
            .foregroundColor: UIColor.init(hexString: "#666666") as Any,
            .font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        ])
        phoneFiled.attributedPlaceholder = attrString
        phoneFiled.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        phoneFiled.textColor = UIColor.init(hexString: "#333333")
        phoneFiled.leftView = UIView(frame: CGRectMake(0, 0, 16, 20))
        phoneFiled.leftViewMode = .always
        return phoneFiled
    }()
    
    lazy var twoListView: LoginListView = {
        let twoListView = LoginListView()
        twoListView.iconImageView.image = UIImage(named: "log_pp_image")
        twoListView.nameLabel.text = LanguageManager.localizedString(for: "Verification Code")
        return twoListView
    }()
    
    lazy var codeView: UIView = {
        let codeView = UIView()
        codeView.backgroundColor = UIColor.init(hexString: "#C0FFEC")
        codeView.layer.cornerRadius = 10
        codeView.layer.masksToBounds = true
        return codeView
    }()
    
    lazy var codeFiled: UITextField = {
        let codeFiled = UITextField()
        codeFiled.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: LanguageManager.localizedString(for: "Verification Code"), attributes: [
            .foregroundColor: UIColor.init(hexString: "#666666") as Any,
            .font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        ])
        codeFiled.attributedPlaceholder = attrString
        codeFiled.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        codeFiled.textColor = UIColor.init(hexString: "#333333")
        codeFiled.leftView = UIView(frame: CGRectMake(0, 0, 16, 20))
        codeFiled.leftViewMode = .always
        return codeFiled
    }()
    
    lazy var voiceImageView: UIImageView = {
        let voiceImageView = UIImageView()
        voiceImageView.image = languageCode == "id" ? UIImage(named: "vo_ed_image") : UIImage(named: "vo_en_image")
        voiceImageView.contentMode = .scaleAspectFit
        voiceImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleVoiceTap(_:)))
        voiceImageView.addGestureRecognizer(tapGesture)
        return voiceImageView
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        loginBtn.setBackgroundImage(UIImage(named: "guide_btn_image"), for: .normal)
        loginBtn.setTitle(LanguageManager.localizedString(for: "Log in"), for: .normal)
        loginBtn.adjustsImageWhenHighlighted = false
        return loginBtn
    }()
    
    lazy var codeBtn: UIButton = {
        let codeBtn = UIButton(type: .custom)
        codeBtn.setTitleColor(.white, for: .normal)
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(600))
        codeBtn.setBackgroundImage(languageCode == "id" ? UIImage(named: "code_id_image") : UIImage(named: "code_en_image"), for: .normal)
        codeBtn.setTitle(LanguageManager.localizedString(for: "Get Code"), for: .normal)
        codeBtn.adjustsImageWhenHighlighted = false
        return codeBtn
    }()
    
    lazy var cycleBtn: UIButton = {
        let cycleBtn = UIButton(type: .custom)
        cycleBtn.isSelected = true
        cycleBtn.setImage(UIImage(named: "cy_nor_image"), for: .normal)
        cycleBtn.setImage(UIImage(named: "cy_sel_image"), for: .selected)
        return cycleBtn
    }()
    
    lazy var privacyLabel: UILabel = {
        let privacyLabel = UILabel()
        privacyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let fullText = LanguageManager.localizedString(for: "I have read and agree <Privacy Agreement>")
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.init(hexString: "#6D6D73"),
                                      range: NSRange(location: 0, length: fullText.count))
        
        if let range = fullText.range(of: LanguageManager.localizedString(for: "<Privacy Agreement>")) {
            let nsRange = NSRange(range, in: fullText)
            
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.init(hexString: "#0329F6"),
                                          range: nsRange)
        }
        
        privacyLabel.attributedText = attributedString
        privacyLabel.numberOfLines = 0
        privacyLabel.isUserInteractionEnabled = true
        privacyLabel.textAlignment = .center
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handlePrivacyTap(_:)))
        privacyLabel.addGestureRecognizer(tapGesture)
        return privacyLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(scrollView)
        scrollView.addSubview(goldImageView)
        scrollView.addSubview(whiteView)
        scrollView.addSubview(oneImageView)
        
        whiteView.addSubview(oneListView)
        whiteView.addSubview(phoneView)
        phoneView.addSubview(phoneFiled)
        
        whiteView.addSubview(twoListView)
        whiteView.addSubview(codeView)
        codeView.addSubview(codeBtn)
        codeView.addSubview(codeFiled)
        
        whiteView.addSubview(voiceImageView)
        scrollView.addSubview(cycleBtn)
        scrollView.addSubview(privacyLabel)
        scrollView.addSubview(loginBtn)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        whiteView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(137)
            make.left.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(282)
        }
        goldImageView.snp.makeConstraints { make in
            make.bottom.equalTo(whiteView.snp.top).offset(25)
            make.right.equalTo(whiteView)
            make.size.equalTo(CGSize(width: 117, height: 92))
        }
        oneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 271, height: 63))
        }
        
        oneListView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(24)
        }
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(oneListView.snp.bottom).offset(11)
            make.left.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(54)
        }
        phoneFiled.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        twoListView.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(24)
        }
        codeView.snp.makeConstraints { make in
            make.top.equalTo(twoListView.snp.bottom).offset(11)
            make.left.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(54)
        }
        if languageCode == "id" {
            codeBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 131, height: 37))
                make.right.equalToSuperview().offset(-8)
            }
        }else {
            codeBtn.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 99, height: 37))
                make.right.equalToSuperview().offset(-8)
            }
        }
        
        codeFiled.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(codeBtn.snp.left).offset(-10)
        }
        
        voiceImageView.snp.makeConstraints { make in
            make.top.equalTo(codeView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 180, height: 40))
        }
        scrollView.addSubview(cycleBtn)
        scrollView.addSubview(privacyLabel)
        
        if languageCode == "id" {
            cycleBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(60)
                make.width.height.equalTo(16)
                make.top.equalTo(whiteView.snp.bottom).offset(130)
            }
            privacyLabel.snp.makeConstraints { make in
                make.top.equalTo(cycleBtn)
                make.left.equalTo(cycleBtn.snp.right).offset(6)
                make.width.equalTo(255)
            }
        }else {
            cycleBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(32)
                make.width.height.equalTo(16)
                make.top.equalTo(whiteView.snp.bottom).offset(130)
            }
            privacyLabel.snp.makeConstraints { make in
                make.top.equalTo(cycleBtn)
                make.left.equalTo(cycleBtn.snp.right).offset(6)
                make.width.equalTo(290)
            }
        }
        
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(privacyLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 299.pix(), height: 46.pix()))
            make.bottom.equalToSuperview().offset(-40)
        }
        
        cycleBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                cycleBtn.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        loginBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.loginBlock?()
            })
            .disposed(by: disposeBag)
        
        codeBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.codeBlock?("normal")
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView {
    
    @objc private func handlePrivacyTap(_ gesture: UITapGestureRecognizer) {
        ToastManager.showMessage("1")
    }
    
    @objc private func handleVoiceTap(_ gesture: UITapGestureRecognizer) {
        self.codeBlock?("voice")
    }
}
