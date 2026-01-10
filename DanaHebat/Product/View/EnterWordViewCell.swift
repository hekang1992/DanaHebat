//
//  EnterWordViewCell.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class EnterWordViewCell: UITableViewCell {
    
    var enterTextChanged: ((String?) -> Void)?
    
    var model: showedModel? {
        didSet {
            guard let model = model else { return }
            let market = model.market ?? ""
            codeFiled.keyboardType = market == "1" ? .numberPad : .default
            nameLabel.text = model.tightly ?? ""
            codeFiled.placeholder = model.infected ?? ""
            codeFiled.text = model.orthoreoviruses ?? ""
        }
    }
    
    private let disposeBag = DisposeBag()
    
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
        return codeFiled
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(codeFiled)
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 80.pix()))
            make.bottom.equalToSuperview()
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
            make.right.equalToSuperview().offset(-5.pix())
        }
        
        codeFiled.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.enterTextChanged?(text)
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
