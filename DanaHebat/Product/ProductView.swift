//
//  ProductView.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit
import Kingfisher

class ProductView: UIView {
    
    var model: BaseModel? {
        didSet {
            guard let listArray = model?.potions?.five else { return }
            reloadDynamicViews(listArray)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.layer.cornerRadius = 16.pix()
        oneView.layer.masksToBounds = true
        return oneView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 12.pix()
        whiteView.layer.masksToBounds = true
        return whiteView
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.cornerRadius = 16.pix()
        layer.colors = [
            UIColor(hexString: "#00F8AE").cgColor,
            UIColor(hexString: "#0099CD").cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        return layer
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        applyBtn.setBackgroundImage(UIImage(named: "guide_btn_image"), for: .normal)
        return applyBtn
    }()
    
    lazy var goldImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "go_p_c_image")
        return iv
    }()
    
    lazy var oneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#333333")
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var twoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#333333")
        label.font = .systemFont(ofSize: 40, weight: .black)
        return label
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#BBF1FF")
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var oneListView = HomeListView()
    lazy var twoListView = HomeListView()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Certification Qualifications"
        label.font = .systemFont(ofSize: 16, weight: .black)
        return label
    }()
    
    lazy var bgImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "cer_d_image"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var stepLabel: UILabel = {
        let label = UILabel()
        label.text = "Certification Process"
        label.font = .systemFont(ofSize: 16, weight: .black)
        return label
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor(hexString: "#BFFFEC")
        coverView.layer.cornerRadius = 16.pix()
        coverView.layer.masksToBounds = true
        return coverView
    }()
    
    private var listViews: [ProductListView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(scrollView)
        addSubview(applyBtn)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(oneView)
        oneView.addSubview(whiteView)
        whiteView.addSubview(goldImageView)
        whiteView.addSubview(oneLabel)
        whiteView.addSubview(twoLabel)
        whiteView.addSubview(bgView)
        bgView.addSubview(oneListView)
        bgView.addSubview(twoListView)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(bgImageView)
        contentView.addSubview(stepLabel)
        contentView.addSubview(coverView)
        
        oneView.layer.insertSublayer(gradientLayer, at: 0)
        
        applyBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30.pix())
            make.size.equalTo(CGSize(width: 299.pix(), height: 46.pix()))
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(applyBtn.snp.top).offset(-5.pix())
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        oneView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 194.pix()))
        }
        
        whiteView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(13.pix())
        }
        
        goldImageView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(93.pix())
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(15.pix())
        }
        
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(2.pix())
            make.left.equalTo(oneLabel)
        }
        
        bgView.snp.makeConstraints { make in
            make.left.equalTo(oneLabel)
            make.top.equalTo(twoLabel.snp.bottom).offset(8.pix())
            make.size.equalTo(CGSize(width: 288.pix(), height: 60.pix()))
        }
        
        oneListView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 144.pix(), height: 60.pix()))
        }
        
        twoListView.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 144.pix(), height: 60.pix()))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(14)
            make.left.equalTo(oneView)
        }
        
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 86.pix()))
        }
        
        stepLabel.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(14)
            make.left.equalTo(oneView)
        }
        
        coverView.snp.makeConstraints { make in
            make.top.equalTo(stepLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16.pix())
            make.bottom.equalToSuperview().offset(-5.pix())
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = oneView.bounds
    }
    
    private func reloadDynamicViews(_ list: [fiveModel]) {
        listViews.forEach { $0.removeFromSuperview() }
        listViews.removeAll()
        var lastView: UIView = stepLabel
        for (index, model) in list.enumerated() {
            let itemView = ProductListView(frame: .zero)
            contentView.addSubview(itemView)
            let gnaw = model.gnaw ?? 0
            itemView.arrowImageView.image = gnaw == 1 ? UIImage(named: "com_li_p_imge") : UIImage(named: "nor_li_p_imge")
            itemView.nameLabel.text = model.tightly ?? ""
            itemView.logoImageView.kf.setImage(with: URL(string: model.identified ?? ""))
            itemView.snp.makeConstraints { make in
                make.top.equalTo(lastView.snp.bottom).offset(index == 0 ? 24 : 12)
                make.centerX.equalToSuperview()
                make.size.equalTo(CGSize(width: 320.pix(), height: 60.pix()))
            }
            lastView = itemView
            listViews.append(itemView)
        }
        
        lastView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15.pix())
        }
    }
}



