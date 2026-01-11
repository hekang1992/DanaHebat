//
//  TapContactViewCell 2.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//


import UIKit
import SnapKit
import RxCocoa
import RxSwift

class TapContactViewCell: UITableViewCell {
    
    var model: showedModel? {
        didSet {
            guard let model = model else { return }
            mainLabel.text = model.tightly ?? ""
            nameLabel.text = model.animal ?? ""
            codeFiled.placeholder = model.outbreak ?? ""
            
            let causative = model.causative ?? ""
            
            let modelArray = model.linked ?? []
            
            if let foundModel = modelArray.first(where: { $0.almost == causative }) {
                codeFiled.text = foundModel.crawl ?? ""
            }
            
            phoneLabel.text = model.zoonosis ?? ""
            phoneFiled.placeholder = model.health ?? ""
            let phone = "\(model.crawl ?? "")-\(model.possible ?? "")"
            phoneFiled.text = phone == "-" ? "" : phone
            
        }
    }
    
    var tapCellBlock: ((showedModel) -> Void)?
    
    var phoneCellBlock: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "fle_a_image")
        return logoImageView
    }()
    
    lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.textAlignment = .left
        mainLabel.textColor = UIColor.init(hexString: "#333333")
        mainLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(600))
        return mainLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 12.pix()
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        return bgView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        return nameLabel
    }()
    
    lazy var codeFiled: UITextField = {
        let codeFiled = UITextField()
        codeFiled.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        codeFiled.textColor = UIColor.init(hexString: "#333333")
        codeFiled.isEnabled = false
        return codeFiled
    }()
    
    lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "ri_ic_a_image")
        return arrowImageView
    }()
    
    lazy var tapBtn: UIButton = {
        let tapBtn = UIButton(type: .custom)
        return tapBtn
    }()
    
    lazy var phoneView: UIView = {
        let phoneView = UIView()
        phoneView.layer.cornerRadius = 12.pix()
        phoneView.layer.masksToBounds = true
        phoneView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        return phoneView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = UIColor.init(hexString: "#333333")
        phoneLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        return phoneLabel
    }()
    
    lazy var phoneFiled: UITextField = {
        let phoneFiled = UITextField()
        phoneFiled.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        phoneFiled.textColor = UIColor.init(hexString: "#333333")
        phoneFiled.isEnabled = false
        return phoneFiled
    }()
    
    lazy var phoneImageView: UIImageView = {
        let phoneImageView = UIImageView()
        phoneImageView.image = UIImage(named: "ph_la_image")
        return phoneImageView
    }()
    
    lazy var phoneBtn: UIButton = {
        let phoneBtn = UIButton(type: .custom)
        return phoneBtn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(logoImageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(codeFiled)
        bgView.addSubview(arrowImageView)
        
        contentView.addSubview(phoneView)
        phoneView.addSubview(phoneLabel)
        phoneView.addSubview(phoneFiled)
        phoneView.addSubview(phoneImageView)
        phoneView.addSubview(phoneBtn)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.pix())
            make.left.equalToSuperview().offset(18.pix())
            make.width.height.equalTo(18.pix())
        }
        
        mainLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(5.pix())
            make.centerY.equalTo(logoImageView)
            make.height.equalTo(20)
        }
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(15.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 80.pix()))
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14.pix())
            make.left.equalToSuperview().offset(16.pix())
            make.height.equalTo(22.pix())
        }
        codeFiled.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-4.pix())
            make.right.equalToSuperview().offset(-35.pix())
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(codeFiled)
            make.right.equalToSuperview().offset(-15.pix())
            make.width.height.equalTo(15.pix())
        }
        
        bgView.addSubview(tapBtn)
        tapBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(12.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 80.pix()))
            make.bottom.equalToSuperview().offset(-10.pix())
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14.pix())
            make.left.equalToSuperview().offset(16.pix())
            make.height.equalTo(22.pix())
        }
        phoneFiled.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel)
            make.top.equalTo(phoneLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-4.pix())
            make.right.equalToSuperview().offset(-35.pix())
        }
        phoneImageView.snp.makeConstraints { make in
            make.centerY.equalTo(phoneFiled)
            make.right.equalToSuperview().offset(-15.pix())
            make.size.equalTo(CGSize(width: 12.pix(), height: 7.pix()))
        }
        
        phoneView.addSubview(phoneBtn)
        phoneBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tapBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self, let model = model else { return }
                self.tapCellBlock?(model)
            })
            .disposed(by: disposeBag)
        
        phoneBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self, let model = model else { return }
                self.phoneCellBlock?()
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
