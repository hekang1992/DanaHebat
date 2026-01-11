//
//  HomeRatetListView.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import UIKit
import SnapKit

class HomeRatetListView: UIView {
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "pla_desc_image")
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return nameLabel
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5.pix()
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.textColor = UIColor.init(hexString: "#666666")
        descLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return descLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        addSubview(descLabel)
        
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(nameLabel)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(21.pix())
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(2.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(20.pix())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
