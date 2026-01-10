//
//  FaceViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit

class FaceViewController: BaseViewController {
    
    var appTitle: String = ""
    
    var productID: String = ""
    
    private let viewModel = HttpViewModel()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = languageCode == "id" ? UIImage(named: "fc_e_n_image") : UIImage(named: "fc_d_i_image")
        oneImageView.contentMode = .scaleAspectFit
        return oneImageView
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.setTitle(LanguageManager.localizedString(for: "Next"), for: .normal)
        applyBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(600))
        applyBtn.setBackgroundImage(UIImage(named: "guide_btn_image"), for: .normal)
        return applyBtn
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneListView: FaceListView = {
        let oneListView = FaceListView(frame: .zero)
        return oneListView
    }()
    
    lazy var twoListView: FaceListView = {
        let twoListView = FaceListView(frame: .zero)
        return twoListView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(appHeadView)
        appHeadView.configTitle(with: appTitle)
        appHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        appHeadView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(oneImageView)
        oneImageView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(123.pix())
        }
        
        view.addSubview(applyBtn)
        applyBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30.pix())
            make.size.equalTo(CGSize(width: 299.pix(), height: 46.pix()))
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(applyBtn.snp.top).offset(-10.pix())
        }
        
        scrollView.addSubview(oneListView)
        scrollView.addSubview(twoListView)
        
        oneListView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.pix())
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(284.pix())
        }
        
        twoListView.snp.makeConstraints { make in
            make.top.equalTo(oneListView.snp.bottom).offset(12.pix())
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(284.pix())
            make.bottom.equalToSuperview().offset(-30.pix())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.getPersonalInfo()
        }
    }
    
}

extension FaceViewController {
    
    private func getPersonalInfo() async {
        do {
            let parameters = ["will": productID]
            let model = try await viewModel.getPersonalDetailApi(parameters: parameters)
            if model.illness == 0 {
                
            }
        } catch {
            
        }
    }
    
}
