//
//  OrderListViewCell.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import UIKit
import SnapKit
import Kingfisher

class OrderListViewCell: UITableViewCell {
    
    var model: certainlyModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.asthma ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.ecological ?? ""
            typeLabel.text = model.treat ?? ""
            
            let listArray = model.hilli ?? []
            setupListViews(with: listArray)
            
            let stoliczka = model.stoliczka ?? ""
            loanLabel.isHidden = stoliczka.isEmpty
            loanLabel.text = stoliczka
        }
    }
    
    private var listViews: [UIView] = []
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "od_o_a_image")
        bgImageView.contentMode = .scaleAspectFit
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
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return nameLabel
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.layer.cornerRadius = 16.pix()
        whiteView.layer.masksToBounds = true
        whiteView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        return whiteView
    }()
    
    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textAlignment = .center
        typeLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        typeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return typeLabel
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
        applyLabel.text = LanguageManager.localizedString(for: "Check Details")
        applyLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        applyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return applyLabel
    }()
    
    lazy var loanLabel: UILabel = {
        let loanLabel = UILabel()
        loanLabel.textAlignment = .left
        loanLabel.textColor = UIColor.init(hexString: "#333333")
        loanLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        
        let attributedString = NSMutableAttributedString(string: "您的文本内容")
        attributedString.addAttribute(.underlineStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSRange(location: 0, length: attributedString.length))
        loanLabel.attributedText = attributedString
        
        return loanLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(logoImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(whiteView)
        bgImageView.addSubview(typeLabel)
        bgImageView.addSubview(applyImageView)
        applyImageView.addSubview(applyLabel)
        bgImageView.addSubview(loanLabel)
        
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 225.pix()))
            make.bottom.equalToSuperview().offset(-11.pix())
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.pix())
            make.left.equalToSuperview().offset(12.pix())
            make.width.height.equalTo(30.pix())
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(8.pix())
            make.height.equalTo(21.pix())
        }
        whiteView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(8.pix())
            make.size.equalTo(CGSize(width: 320.pix(), height: 122.pix()))
        }
        typeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7.pix())
            make.right.equalToSuperview().offset(-22.pix())
            make.size.equalTo(CGSize(width: 110.pix(), height: 23.pix()))
        }
        applyImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 130.pix(), height: 34.pix()))
            make.bottom.right.equalToSuperview().inset(12.pix())
        }
        applyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loanLabel.snp.makeConstraints { make in
            make.centerY.equalTo(applyImageView)
            make.left.equalToSuperview().offset(17.pix())
            make.height.equalTo(18.pix())
        }
    }
    
    private func setupListViews(with listArray: [hilliModel]) {
        listViews.forEach { $0.removeFromSuperview() }
        listViews.removeAll()
        
        guard !listArray.isEmpty else { return }
        
        var previousView: UIView?
        
        for (index, model) in listArray.enumerated() {
            let itemView = OrderContentListView(frame: .zero)
            whiteView.addSubview(itemView)
            listViews.append(itemView)
            itemView.nameLabel.text = model.tightly ?? ""
            itemView.contentLabel.text = model.trident ?? ""
            itemView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                
                if let previous = previousView {
                    make.top.equalTo(previous.snp.bottom).offset(8.pix())
                } else {
                    make.top.equalToSuperview().offset(12.pix())
                }
                
                make.height.greaterThanOrEqualTo(20.pix())
                
                if index == listArray.count - 1 {
                    make.bottom.lessThanOrEqualToSuperview().offset(-10.pix())
                }
            }
            
            previousView = itemView
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        listViews.forEach { $0.removeFromSuperview() }
        listViews.removeAll()
        logoImageView.kf.cancelDownloadTask()
        logoImageView.image = nil
        nameLabel.text = nil
        typeLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
