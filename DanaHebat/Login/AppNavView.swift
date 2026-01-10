//
//  AppNavView.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AppNavView: UIView {
    
    var backBlock: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setBackgroundImage(UIImage(named: "app_back_image"), for: .normal)
        backBtn.adjustsImageWhenHighlighted = false
        return backBtn
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center        
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        return nameLabel
    }()
    
    lazy var statusBarView: UIView = {
        let statusBarView = UIView()
        statusBarView.backgroundColor = .white
        return statusBarView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension AppNavView {
    
    func setupUI() {
        addSubview(statusBarView)
        addSubview(contentView)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(backBtn)
    }
    
    func setupConstraints() {
        
        statusBarView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(statusBarView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(260)
        }
        
        backBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        backBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.backBlock?()
            })
            .disposed(by: disposeBag)
    }
}

extension AppNavView {
    
    func configTitle(with title: String) {
        nameLabel.text = title
    }
}
