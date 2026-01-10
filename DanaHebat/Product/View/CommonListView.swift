//
//  CommonListView.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit

class CommonListView: UIView {
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 10.pix()
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hexString: "#BFFFEC")
        return bgView
    }()
    
    lazy var enterFiled: UITextField = {
        let enterFiled = UITextField()
        enterFiled.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        enterFiled.textColor = UIColor.init(hexString: "#333333")
        enterFiled.leftView = UIView(frame: CGRectMake(0, 0, 16, 20))
        enterFiled.leftViewMode = .always
        enterFiled.rightView = UIView(frame: CGRectMake(0, 0, 16, 20))
        enterFiled.rightViewMode = .always
        return enterFiled
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(bgView)
        bgView.addSubview(enterFiled)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12.pix())
            make.left.equalToSuperview().offset(23.pix())
            make.height.equalTo(22.pix())
        }
        bgView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10.pix())
            make.left.equalTo(nameLabel)
            make.height.equalTo(54.pix())
            make.centerX.equalToSuperview()
        }
        enterFiled.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
