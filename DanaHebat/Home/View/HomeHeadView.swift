//
//  HomeHeadView.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit

class HomeHeadView: UIView {
    
    var tapClickBlock: (() -> Void)?
    
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
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 8.pix()
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var nameLabel: StrokeLabel = {
        let nameLabel = StrokeLabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor(hexString: "#FFFFFF")
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(400))
        nameLabel.strokeColor = UIColor(hexString: "#0329F6")
        nameLabel.strokeWidth = 2.0
        return nameLabel
    }()
    
    lazy var centerBtn: UIButton = {
        let centerBtn = UIButton(type: .custom)
        centerBtn.setBackgroundImage(UIImage(named: "p_logo_image"), for: .normal)
        centerBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return centerBtn
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

private extension HomeHeadView {
    
    func setupUI() {
        addSubview(statusBarView)
        addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(centerBtn)
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
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16.pix())
            make.width.height.equalTo(28.pix())
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(logoImageView.snp.right).offset(10.pix())
            make.height.equalTo(22.pix())
        }
        
        centerBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15.pix())
            make.width.height.equalTo(37.pix())
        }
    }
}

extension HomeHeadView {
   
    @objc func btnClick() {
        self.tapClickBlock?()
    }
    
}
