//
//  HomeProductListViewCell.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import UIKit
import SnapKit
import Kingfisher

class HomeProductListViewCell: UITableViewCell {
    
    var model: newarModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.asthma ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.ecological ?? ""
            applyLabel.text = model.treat ?? ""
            oneListView.nameLabel.text = model.reported ?? ""
            oneListView.descLabel.text = model.flesh ?? ""
            
            twoListView.nameLabel.text = model.philippines ?? ""
            twoListView.descLabel.text = model.naga ?? ""
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "li_t_b_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5.pix()
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return nameLabel
    }()
    
    lazy var lineImageView: UIImageView = {
        let lineImageView = UIImageView()
        lineImageView.image = UIImage(named: "p_line_image")
        return lineImageView
    }()
    
    lazy var applyImageView: UIImageView = {
        let applyImageView = UIImageView()
        applyImageView.image = UIImage(named: "aly_a_im_age")
        applyImageView.contentMode = .scaleAspectFit
        return applyImageView
    }()
    
    lazy var applyLabel: UILabel = {
        let applyLabel = UILabel()
        applyLabel.textAlignment = .center
        applyLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        applyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return applyLabel
    }()
    
    lazy var oneListView: HomeRatetListView = {
        let oneListView = HomeRatetListView()
        oneListView.logoImageView.image = UIImage(named: "ca_a_i_age")
        return oneListView
    }()
    
    lazy var twoListView: HomeRatetListView = {
        let twoListView = HomeRatetListView()
        twoListView.logoImageView.image = UIImage(named: "cat_a_i_age")
        return twoListView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(logoImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(lineImageView)
        bgImageView.addSubview(applyImageView)
        applyImageView.addSubview(applyLabel)
        bgImageView.addSubview(oneListView)
        bgImageView.addSubview(twoListView)
        bgImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 343.pix(), height: 129.pix()))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10.pix())
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13.pix())
            make.left.equalToSuperview().offset(12.pix())
            make.width.height.equalTo(38.pix())
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(8.pix())
            make.height.equalTo(20.pix())
        }
        lineImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(11.pix())
            make.size.equalTo(CGSize(width: 317.pix(), height: 2.pix()))
        }
        applyImageView.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.right.equalToSuperview().offset(-12.pix())
            make.size.equalTo(CGSize(width: 130.pix(), height: 34.pix()))
        }
        applyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        oneListView.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(lineImageView.snp.bottom)
            make.width.equalTo(167.pix())
        }
        twoListView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.top.equalTo(lineImageView.snp.bottom)
            make.width.equalTo(167.pix())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
