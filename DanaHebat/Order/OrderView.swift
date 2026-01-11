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
    
    var emptyClickBlock: (() -> Void)?
    
    var modelArray: [certainlyModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
            if modelArray.count > 0 {
                tableView.isHidden = false
                emptyView.isHidden = true
            }else {
                tableView.isHidden = true
                emptyView.isHidden = false
            }
        }
    }
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle(LanguageManager.localizedString(for: "All"), for: .normal)
        oneBtn.setTitleColor(UIColor.init(hexString: "#333333"), for: .normal)
        oneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
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
        twoBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
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
        threeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
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
        fourBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100.pix()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(OrderListViewCell.self, forCellReuseIdentifier: "OrderListViewCell")
        tableView.isHidden = true
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var emptyView: OrderEmptyView = {
        let emptyView = OrderEmptyView()
        emptyView.isHidden = true
        return emptyView
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
        addSubview(tableView)
        addSubview(emptyView)
        scrollView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(60.pix())
        }
        
        oneBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 70.pix(), height: 40.pix()))
            make.left.equalToSuperview().offset(8.pix())
        }
        
        twoBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 120.pix(), height: 40.pix()))
            make.left.equalTo(oneBtn.snp.right).offset(6.pix())
        }
        
        threeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 120.pix(), height: 40.pix()))
            make.left.equalTo(twoBtn.snp.right).offset(6.pix())
        }
        
        fourBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 70.pix(), height: 40.pix()))
            make.left.equalTo(threeBtn.snp.right).offset(6.pix())
            make.right.equalToSuperview().offset(-8.pix())
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        emptyView.onTap = { [weak self] in
            guard let self = self else { return }
            self.emptyClickBlock?()
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
        
        if sender.tag == 0 {
            scrollToLeft()
        }
        
        if sender.tag == 3 {
            scrollToRight()
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
            gradient.frame = CGRect(x: 0, y: 0, width: button.tag == 0 || button.tag == 3 ? 70.pix() : (button.tag == 1 ? 120.pix() : 120.pix()), height: 40.pix())
        }
        
        button.layer.insertSublayer(gradient, at: 0)
    }
    
    private func scrollToRight() {
        let contentWidth = scrollView.contentSize.width
        let scrollViewWidth = scrollView.bounds.width
        
        if contentWidth > scrollViewWidth {
            let targetOffset = CGPoint(x: contentWidth - scrollViewWidth, y: 0)
            
            UIView.animate(withDuration: 0.2) {
                self.scrollView.contentOffset = targetOffset
            }
        }
    }
    
    func scrollToLeft() {
        UIView.animate(withDuration: 0.2) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
}


extension OrderView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.modelArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListViewCell", for: indexPath) as! OrderListViewCell
        cell.model = model
        return cell
    }
    
}
