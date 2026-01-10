//
//  PersonalNameAlertView 2.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class PersonalNameAlertView: UIView {
    
    var modelArray: [sinicusModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
            let oneModel = modelArray[0]
            let twoModel = modelArray[1]
            let threeModel = modelArray[2]
            
            oneListView.nameLabel.text = oneModel.virus ?? ""
            oneListView.enterFiled.placeholder = oneModel.virus ?? ""
            oneListView.enterFiled.text = oneModel.positive ?? ""
            
            twoListView.nameLabel.text = twoModel.virus ?? ""
            twoListView.enterFiled.placeholder = twoModel.virus ?? ""
            twoListView.enterFiled.text = twoModel.positive ?? ""
            
            threeListView.nameLabel.text = threeModel.virus ?? ""
            threeListView.enterFiled.placeholder = threeModel.virus ?? ""
            threeListView.enterFiled.text = threeModel.positive ?? ""
        }
    }
    
    private let disposeBag = DisposeBag()
    
    var leftBlock: (() -> Void)?
    
    var rightBlock: (() -> Void)?
    
    var timeBlock: ((String, CommonClickView) -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = LanguageManager.shared.getCurrentLocaleCode() == "id" ? UIImage(named: "alt_tid_p_image") : UIImage(named: "alt_t_p_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton(type: .custom)
        return leftBtn
    }()
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton(type: .custom)
        return rightBtn
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.text = LanguageManager.localizedString(for: "Please Confirm")
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 10.pix()
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hexString: "#FFE5C8")
        return bgView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.text = LanguageManager.localizedString(for: "Please check your lD information correctly, once submitted it is not changed again")
        descLabel.textColor = UIColor.init(hexString: "#F14857")
        descLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(400))
        descLabel.numberOfLines = 0
        return descLabel
    }()
    
    lazy var oneListView: CommonListView = {
        let oneListView = CommonListView(frame: .zero)
        return oneListView
    }()
    
    lazy var twoListView: CommonListView = {
        let twoListView = CommonListView(frame: .zero)
        return twoListView
    }()
    
    lazy var threeListView: CommonClickView = {
        let threeListView = CommonClickView(frame: .zero)
        return threeListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(leftBtn)
        bgImageView.addSubview(rightBtn)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(bgView)
        bgView.addSubview(descLabel)
        bgImageView.addSubview(oneListView)
        bgImageView.addSubview(twoListView)
        bgImageView.addSubview(threeListView)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 325.pix(), height: 550.pix()))
        }
        leftBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 157.pix(), height: 60.pix()))
        }
        rightBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 157.pix(), height: 60.pix()))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(44.pix())
            make.height.equalTo(25.pix())
        }
        
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(21.pix())
            make.size.equalTo(CGSize(width: 280.pix(), height: 82.pix()))
        }
        
        descLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10.pix())
        }
        
        oneListView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgView.snp.bottom)
            make.left.equalToSuperview()
            make.height.equalTo(86.pix())
        }
        
        twoListView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneListView.snp.bottom).offset(12.pix())
            make.left.equalToSuperview()
            make.height.equalTo(86.pix())
        }
        
        threeListView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(twoListView.snp.bottom).offset(12.pix())
            make.left.equalToSuperview()
            make.height.equalTo(86.pix())
        }
        
        leftBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.leftBlock?()
            })
            .disposed(by: disposeBag)
        
        rightBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.rightBlock?()
            })
            .disposed(by: disposeBag)
        
        threeListView.tapBlock = { [weak self] in
            guard let self = self else { return }
            let time = threeListView.enterFiled.text ?? ""
            if time.isEmpty {
                self.timeBlock?("25-12-1989", threeListView)
            }else {
                self.timeBlock?(time, threeListView)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
