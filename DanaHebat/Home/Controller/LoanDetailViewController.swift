//
//  LoanDetailViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit

class LoanDetailViewController: BaseViewController {
        
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "log_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = languageCode == "id" ? UIImage(named: "one_od_c_image") : UIImage(named: "one_en_c_image")
        oneImageView.contentMode = .scaleAspectFit
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = languageCode == "id" ? UIImage(named: "on_id_c_image") : UIImage(named: "on_en_c_image")
        twoImageView.contentMode = .scaleAspectFit
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = languageCode == "id" ? UIImage(named: "o_end_c_image") : UIImage(named: "o_en_c_image")
        threeImageView.contentMode = .scaleAspectFit
        return threeImageView
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        fourImageView.image = languageCode == "id" ? UIImage(named: "one_ad_en_c_image") : UIImage(named: "one_a_en_c_image")
        fourImageView.contentMode = .scaleAspectFit
        return fourImageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        applyBtn.setBackgroundImage(UIImage(named: "guide_btn_image"), for: .normal)
        applyBtn.setTitle(LanguageManager.localizedString(for: "Go to Apply"), for: .normal)
        applyBtn.adjustsImageWhenHighlighted = false
        applyBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return applyBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(appHeadView)
        appHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        appHeadView.configTitle(with: LanguageManager.localizedString(for: "Loan Precautions"))
        
        appHeadView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(applyBtn)
        applyBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 299.pix(), height: 46.pix()))
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(applyBtn.snp.top).offset(-5.pix())
        }
        
        scrollView.addSubview(oneImageView)
        scrollView.addSubview(twoImageView)
        scrollView.addSubview(threeImageView)
        scrollView.addSubview(fourImageView)
        
        oneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 343.pix(), height: 154.pix()))
        }
        
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneImageView.snp.bottom).offset(12)
            if languageCode == "id" {
                make.size.equalTo(CGSize(width: 343.pix(), height: 200.pix()))
            }else {
                make.size.equalTo(CGSize(width: 343.pix(), height: 174.pix()))
            }
        }
        
        threeImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(twoImageView.snp.bottom).offset(12)
            if languageCode == "id" {
                make.size.equalTo(CGSize(width: 343.pix(), height: 198.pix()))
            }else {
                make.size.equalTo(CGSize(width: 343.pix(), height: 174.pix()))
            }
        }
        
        fourImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(threeImageView.snp.bottom).offset(12)
            if languageCode == "id" {
                make.size.equalTo(CGSize(width: 343.pix(), height: 200.pix()))
            }else {
                make.size.equalTo(CGSize(width: 343.pix(), height: 174.pix()))
            }
            make.bottom.equalToSuperview().offset(-20.pix())
        }
        
    }
    
    @objc func btnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

