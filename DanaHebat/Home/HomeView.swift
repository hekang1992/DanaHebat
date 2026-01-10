//
//  HomeView.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class HomeView: UIView {
    
    var oneBlock: (() -> Void)?
    
    var twoBlock: (() -> Void)?
    
    var threeBlock: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
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
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = languageCode == "id" ? UIImage(named: "h_one_end_image") : UIImage(named: "h_one_en_image")
        oneImageView.contentMode = .scaleAspectFit
        return oneImageView
    }()
    
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
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = languageCode == "id" ? UIImage(named: "h_ca_ed_image") : UIImage(named: "h_ca_en_image")
        threeImageView.contentMode = .scaleAspectFit
        return threeImageView
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        fourImageView.image = languageCode == "id" ? UIImage(named: "foe_ead_imge") : UIImage(named: "foe_ed_imge")
        fourImageView.contentMode = .scaleAspectFit
        fourImageView.isUserInteractionEnabled = true
        return fourImageView
    }()
    
    lazy var footerImageView: UIImageView = {
        let footerImageView = UIImageView()
        footerImageView.image = UIImage(named: "foe_a_b_image")
        footerImageView.contentMode = .scaleAspectFit
        footerImageView.isUserInteractionEnabled = true
        return footerImageView
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
    
    lazy var loanImageView: UIImageView = {
        let loanImageView = UIImageView()
        loanImageView.image = UIImage(named: "guide_btn_image")
        loanImageView.isUserInteractionEnabled = true
        return loanImageView
    }()
    
    lazy var loanBtn: UIButton = {
        let loanBtn = UIButton(type: .custom)
        loanBtn.setTitle(LanguageManager.localizedString(for: "Loan Precautions"), for: .normal)
        loanBtn.setTitleColor(.white, for: .normal)
        loanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        loanBtn.semanticContentAttribute = .forceRightToLeft
        loanBtn.setImage(UIImage(named: "wh_ar_image"), for: .normal)
        return loanBtn
    }()
    
    lazy var privacyLabel: UILabel = {
        let privacyLabel = UILabel()
        privacyLabel.textAlignment = .left
        privacyLabel.text = LanguageManager.localizedString(for: "Privacy Policy")
        privacyLabel.textColor = UIColor.init(hexString: "#333333")
        privacyLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return privacyLabel
    }()
    
    lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.textAlignment = .center
        detailLabel.text = LanguageManager.localizedString(for: "View Details")
        detailLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        detailLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(600))
        return detailLabel
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        return threeBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(oneImageView)
        scrollView.addSubview(twoImageView)
        scrollView.addSubview(threeImageView)
        scrollView.addSubview(fourImageView)
        scrollView.addSubview(footerImageView)
        footerImageView.addSubview(privacyLabel)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        oneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: 123.pix()))
        }
        twoImageView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 255.pix()))
        }
        threeImageView.snp.makeConstraints { make in
            make.top.equalTo(twoImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 285.pix()))
        }
        fourImageView.snp.makeConstraints { make in
            make.top.equalTo(threeImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 323.pix()))
        }
        footerImageView.snp.makeConstraints { make in
            make.top.equalTo(fourImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 53.pix()))
            make.bottom.equalToSuperview().offset(-40.pix())
        }
        
        twoImageView.addSubview(applyLabel)
        twoImageView.addSubview(oneLabel)
        twoImageView.addSubview(twoLabel)
        twoImageView.addSubview(bgView)
        bgView.addSubview(oneListView)
        bgView.addSubview(twoListView)
        applyLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-13.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 317.pix(), height: 52.pix()))
        }
        oneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29.pix())
            make.height.equalTo(21)
            make.centerX.equalToSuperview()
        }
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(2)
            make.height.equalTo(47)
            make.centerX.equalToSuperview()
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
        
        fourImageView.addSubview(loanImageView)
        loanImageView.addSubview(loanBtn)
        loanImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 299.pix(), height: 46.pix()))
            make.bottom.equalToSuperview().offset(-14.pix())
        }
        loanBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        footerImageView.addSubview(privacyLabel)
        footerImageView.addSubview(detailLabel)
        privacyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(3.pix())
            make.left.equalToSuperview().offset(75.pix())
            make.height.equalTo(22.pix())
        }
        detailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(privacyLabel)
            make.right.equalToSuperview().offset(-5.pix())
            make.height.equalTo(33.pix())
            make.width.equalTo(102.pix())
        }
        
        twoImageView.addSubview(oneBtn)
        fourImageView.addSubview(twoBtn)
        footerImageView.addSubview(threeBtn)
        
        oneBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        twoBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        threeBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        oneBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.oneBlock?()
            })
            .disposed(by: disposeBag)
        
        twoBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.twoBlock?()
            })
            .disposed(by: disposeBag)
        
        threeBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.threeBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
