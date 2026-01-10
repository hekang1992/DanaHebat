//
//  SureDeleteViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SureDeleteViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = HttpViewModel()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "del_bg_b_imge")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "p_logo_image")
        logoImageView.layer.cornerRadius = 50
        logoImageView.layer.masksToBounds = true
        logoImageView.layer.borderWidth = 2
        logoImageView.layer.borderColor = UIColor.white.cgColor
        return logoImageView
    }()
    
    lazy var pImageView: UIImageView = {
        let pImageView = UIImageView()
        pImageView.image = UIImage(named: "ap_v_image")
        return pImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textAlignment = .center
        phoneLabel.text = UserDefaults.standard.object(forKey: "user_c_phone") as? String ?? ""
        phoneLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        phoneLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        return phoneLabel
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = languageCode == "id" ? UIImage(named: "end_del_b_imge") : UIImage(named: "en_del_b_imge")
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = languageCode == "id" ? UIImage(named: "end_des_b_imge") : UIImage(named: "en_des_b_imge")
        return twoImageView
    }()
    
    lazy var cycleBtn: UIButton = {
        let cycleBtn = UIButton(type: .custom)
        cycleBtn.setImage(UIImage(named: "cy_nor_image"), for: .normal)
        cycleBtn.setImage(UIImage(named: "cy_sel_image"), for: .selected)
        return cycleBtn
    }()
    
    lazy var privacyLabel: UILabel = {
        let privacyLabel = UILabel()
        privacyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let fullText = LanguageManager.localizedString(for: "I have read and agreed to the above")
        privacyLabel.textAlignment = .center
        privacyLabel.text = fullText
        privacyLabel.numberOfLines = 0
        return privacyLabel
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitle(LanguageManager.localizedString(for: "Account Cancellation"), for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        sureBtn.setBackgroundImage(UIImage(named: "red_bg_image"), for: .normal)
        sureBtn.adjustsImageWhenHighlighted = false
        return sureBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(appHeadView)
        appHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        appHeadView.configTitle(with: LanguageManager.localizedString(for: "Account Cancellation"))
        
        appHeadView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        scrollView.addSubview(pImageView)
        pImageView.snp.makeConstraints { make in
            make.bottom.equalTo(logoImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 133, height: 36))
        }
        
        pImageView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(oneImageView)
        scrollView.addSubview(twoImageView)
        
        oneImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.pix())
            make.top.equalTo(pImageView.snp.bottom).offset(23.pix())
            make.size.equalTo(CGSize(width: 298.pix(), height: 111.pix()))
        }
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneImageView.snp.bottom).offset(16.pix())
            make.size.equalTo(CGSize(width: 375.pix(), height: 274.pix()))
        }
        
        scrollView.addSubview(cycleBtn)
        scrollView.addSubview(privacyLabel)
        if languageCode == "id" {
            cycleBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(55.pix())
                make.width.height.equalTo(16)
                make.top.equalTo(twoImageView.snp.bottom).offset(60)
            }
            privacyLabel.snp.makeConstraints { make in
                make.left.equalTo(cycleBtn.snp.right).offset(5)
                make.top.equalTo(cycleBtn).offset(-5)
                make.width.equalTo(260)
                make.height.equalTo(40)
            }
        }else {
            cycleBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(58.pix())
                make.width.height.equalTo(16)
                make.top.equalTo(twoImageView.snp.bottom).offset(60)
            }
            privacyLabel.snp.makeConstraints { make in
                make.left.equalTo(cycleBtn.snp.right).offset(5)
                make.centerY.equalTo(cycleBtn)
                make.width.equalTo(240)
            }
        }
        
        scrollView.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(privacyLabel.snp.bottom).offset(8.pix())
            make.size.equalTo(CGSize(width: 299.pix(), height: 46.pix()))
            make.bottom.equalToSuperview().offset(-40.pix())
        }
        
        cycleBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                cycleBtn.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        sureBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                if cycleBtn.isSelected == false {
                    ToastManager.showMessage(LanguageManager.localizedString(for: "Please read and agree to the above content"))
                    return
                }
                Task {
                    await self.deleteInfo()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}

extension SureDeleteViewController {
    
    private func deleteInfo() async {
        do {
            let parameters = ["purported": UserDataManager.getPhone() ?? ""]
            let model = try await viewModel.deleteMineApi(parameters: parameters)
            ToastManager.showMessage(model.mental ?? "")
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if model.illness == 0 {
                UserDataManager.clearAllUserData()
                self.changeRootVc()
            }
        } catch {
            
        }
    }
    
}
