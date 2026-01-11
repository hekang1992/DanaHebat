//
//  OrderView.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import UIKit
import SnapKit

class OrderView: UIView {
    
    private var selectedButton: UIButton?
    
    var tapClickBlock: ((String) -> Void)?
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle(LanguageManager.localizedString(for: "All"), for: .normal)
        oneBtn.setTitleColor(UIColor.init(hexString: "#333333"), for: .normal)
        oneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(700))
        oneBtn.layer.cornerRadius = 20.pix()
        oneBtn.layer.masksToBounds = true
        oneBtn.layer.borderWidth = 1
        oneBtn.layer.borderColor = UIColor(hexString: "#E6E6E6").cgColor
        oneBtn.backgroundColor = .white
        oneBtn.tag = 0
        oneBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setTitle(LanguageManager.localizedString(for: "Apply"), for: .normal)
        twoBtn.setTitleColor(UIColor.init(hexString: "#333333"), for: .normal)
        twoBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(700))
        twoBtn.layer.cornerRadius = 20.pix()
        twoBtn.layer.masksToBounds = true
        twoBtn.layer.borderWidth = 1
        twoBtn.layer.borderColor = UIColor(hexString: "#E6E6E6").cgColor
        twoBtn.backgroundColor = .white
        twoBtn.tag = 1
        twoBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.setTitle(LanguageManager.localizedString(for: "Repayment"), for: .normal)
        threeBtn.setTitleColor(UIColor.init(hexString: "#333333"), for: .normal)
        threeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(700))
        threeBtn.layer.cornerRadius = 20.pix()
        threeBtn.layer.masksToBounds = true
        threeBtn.layer.borderWidth = 1
        threeBtn.layer.borderColor = UIColor(hexString: "#E6E6E6").cgColor
        threeBtn.backgroundColor = .white
        threeBtn.tag = 2
        threeBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return threeBtn
    }()
    
    lazy var fourBtn: UIButton = {
        let fourBtn = UIButton(type: .custom)
        fourBtn.setTitle(LanguageManager.localizedString(for: "Finished"), for: .normal)
        fourBtn.setTitleColor(UIColor.init(hexString: "#333333"), for: .normal)
        fourBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(700))
        fourBtn.layer.cornerRadius = 20.pix()
        fourBtn.layer.masksToBounds = true
        fourBtn.layer.borderWidth = 1
        fourBtn.layer.borderColor = UIColor(hexString: "#E6E6E6").cgColor
        fourBtn.backgroundColor = .white
        fourBtn.tag = 3
        fourBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return fourBtn
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.selectFirstButtonWithoutCallback()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let selectedButton = selectedButton {
            if let gradientLayer = selectedButton.layer.sublayers?.first(where: { $0.name == "gradientLayer" }) as? CAGradientLayer {
                gradientLayer.frame = selectedButton.bounds
            }
        }
    }
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(oneBtn)
        scrollView.addSubview(twoBtn)
        scrollView.addSubview(threeBtn)
        scrollView.addSubview(fourBtn)
        
        scrollView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(60.pix())
        }
        
        oneBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 88.pix(), height: 40.pix()))
            make.left.equalToSuperview().offset(8.pix())
        }
        
        twoBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 140.pix(), height: 40.pix()))
            make.left.equalTo(oneBtn.snp.right).offset(6.pix())
        }
        
        threeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 136.pix(), height: 40.pix()))
            make.left.equalTo(twoBtn.snp.right).offset(6.pix())
        }
        
        fourBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 88.pix(), height: 40.pix()))
            make.left.equalTo(threeBtn.snp.right).offset(6.pix())
            make.right.equalToSuperview().offset(-8.pix())
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if sender === selectedButton {
            return
        }
        
        updateSelectedButton(sender)
        
        switch sender.tag {
        case 0:
            self.tapClickBlock?("4")
        case 1:
            self.tapClickBlock?("7")
        case 2:
            self.tapClickBlock?("6")
        case 3:
            self.tapClickBlock?("5")
        default:
            break
        }
    }
    
    private func updateSelectedButton(_ button: UIButton) {
        if let selectedButton = selectedButton {
            selectedButton.layer.sublayers?.removeAll(where: { $0.name == "gradientLayer" })
            selectedButton.layer.borderWidth = 1
            selectedButton.layer.borderColor = UIColor(hexString: "#E6E6E6").cgColor
            selectedButton.setTitleColor(UIColor.init(hexString: "#333333"), for: .normal)
            selectedButton.backgroundColor = .white
        }
        
        selectedButton = button
        button.layer.borderWidth = 0
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        
        addGradientBackground(to: button)
    }
    
    private func selectFirstButtonWithoutCallback() {
        updateSelectedButton(oneBtn)
    }
    
    // MARK: - Gradient Methods
    private func addGradientBackground(to button: UIButton) {
        button.layer.sublayers?.removeAll(where: { $0.name == "gradientLayer" })
        
        let gradient = CAGradientLayer()
        gradient.name = "gradientLayer"
        
        let startColor = UIColor(hexString: "#00F8AE")
        let endColor = UIColor(hexString: "#0099CD")
        
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        gradient.cornerRadius = button.layer.cornerRadius
        gradient.masksToBounds = true
        
        if button.bounds.width > 0 && button.bounds.height > 0 {
            gradient.frame = button.bounds
        } else {
            gradient.frame = CGRect(x: 0, y: 0, width: button.tag == 0 || button.tag == 3 ? 88.pix() : (button.tag == 1 ? 140.pix() : 136.pix()), height: 40.pix())
        }
        
        button.layer.insertSublayer(gradient, at: 0)
    }
    
}

