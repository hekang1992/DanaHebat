//
//  FaceListView.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit

class FaceListView: UIView {
    
    var tapClickBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "d_face_i_image")
        bgImageView.contentMode = .scaleAspectFit
        return bgImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.layer.cornerRadius = 12.pix()
        whiteView.layer.masksToBounds = true
        whiteView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        return whiteView
    }()
    
    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textAlignment = .center
        typeLabel.text = LanguageManager.localizedString(for: "Upload")
        typeLabel.textColor = UIColor.init(hexString: "#333333")
        typeLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(600))
        typeLabel.layer.cornerRadius = 15.pix()
        typeLabel.layer.masksToBounds = true
        typeLabel.backgroundColor = UIColor.init(hexString: "#FFF26B")
        return typeLabel
    }()
    
    lazy var cImageView: UIImageView = {
        let cImageView = UIImageView()
        cImageView.layer.cornerRadius = 12.pix()
        cImageView.layer.masksToBounds = true
        return cImageView
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return applyBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(whiteView)
        bgImageView.addSubview(typeLabel)
        addSubview(applyBtn)
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 284.pix()))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5.pix())
            make.height.equalTo(32.pix())
        }
        whiteView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(53.pix())
            make.size.equalTo(CGSize(width: 317.pix(), height: 156.pix()))
        }
        typeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-13.pix())
            make.size.equalTo(CGSize(width: 317.pix(), height: 52.pix()))
        }
        whiteView.addSubview(cImageView)
        cImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 168.pix(), height: 109.pix()))
        }
        applyBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FaceListView {
    
    @objc func btnClick() {
        self.tapClickBlock?()
    }
}
