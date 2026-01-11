//
//  HomeProductHeadViewCell.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import UIKit
import SnapKit

class HomeProductHeadViewCell: UITableViewCell {
    
    let languageCode = LanguageManager.shared.getCurrentLocaleCode()
    
    var model: newarModel? {
        didSet {
            guard let model = model else { return }
            applyLabel.text = model.treat ?? ""
            oneLabel.text = model.flesh ?? ""
            twoLabel.text = model.reported ?? ""
            
            oneListView.oneLabel.text = model.northeast ?? ""
            oneListView.twoLabel.text = model.people ?? ""
            
            twoListView.oneLabel.text = model.naga ?? ""
            twoListView.twoLabel.text = model.ao ?? ""
        }
    }

    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "ho_en_one_image")
        twoImageView.contentMode = .scaleAspectFit
        twoImageView.isUserInteractionEnabled = true
        return twoImageView
    }()
    
    lazy var applyLabel: UILabel = {
        let applyLabel = UILabel()
        applyLabel.textAlignment = .center
        applyLabel.textColor = UIColor.init(hexString: "#333333")
        applyLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(400))
        applyLabel.backgroundColor = UIColor.init(hexString: "#FFF26B")
        applyLabel.layer.cornerRadius = 16.pix()
        applyLabel.layer.masksToBounds = true
        return applyLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .center
        oneLabel.textColor = UIColor.init(hexString: "#333333")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .center
        twoLabel.textColor = UIColor.init(hexString: "#333333")
        twoLabel.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight(900))
        return twoLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hexString: "#BBF1FF")
        return bgView
    }()
    
    lazy var oneListView: HomeListView = {
        let oneListView = HomeListView(frame: .zero)
        return oneListView
    }()
    
    lazy var twoListView: HomeListView = {
        let twoListView = HomeListView(frame: .zero)
        return twoListView
    }()
    
    lazy var goldImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "go_p_c_image")
        return iv
    }()
    
    lazy var footLabel: UILabel = {
        let footLabel = UILabel()
        footLabel.textAlignment = .left
        footLabel.textColor = UIColor.init(hexString: "#333333")
        footLabel.text = LanguageManager.localizedString(for: "Popular Products")
        footLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(900))
        return footLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(twoImageView)
        contentView.addSubview(footLabel)
        twoImageView.addSubview(applyLabel)
        twoImageView.addSubview(oneLabel)
        twoImageView.addSubview(twoLabel)
        twoImageView.addSubview(goldImageView)
        twoImageView.addSubview(bgView)
        bgView.addSubview(oneListView)
        bgView.addSubview(twoListView)
        
        twoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 255.pix()))
        }
        
        applyLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-13.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 317.pix(), height: 52.pix()))
        }
        oneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29.pix())
            make.height.equalTo(21)
            make.left.equalToSuperview().offset(28.pix())
        }
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(2)
            make.height.equalTo(47)
            make.left.equalTo(oneLabel)
        }
        goldImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.pix())
            make.right.equalToSuperview()
            make.width.height.equalTo(93.pix())
        }
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 288.pix(), height: 60.pix()))
            make.top.equalTo(twoLabel.snp.bottom).offset(8.pix())
        }
        oneListView.snp.makeConstraints { make in
            make.height.equalTo(60.pix())
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(144.pix())
        }
        twoListView.snp.makeConstraints { make in
            make.height.equalTo(60.pix())
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(144.pix())
        }
        
        footLabel.snp.makeConstraints { make in
            make.top.equalTo(twoImageView.snp.bottom).offset(12.pix())
            make.left.equalTo(16.pix())
            make.height.equalTo(20.pix())
            make.bottom.equalToSuperview().offset(-10.pix())
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
