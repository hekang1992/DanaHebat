//
//  MineViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit
import SnapKit
import MJRefresh

class MineViewController: BaseViewController {
    
    private let viewModel = HttpViewModel()
    private var buttonContainerView: UIView?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "log_bg_image")
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
        phoneLabel.textColor = UIColor.init(hexString: "#FFFFFF")
        phoneLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        return phoneLabel
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.backgroundColor = .systemPink
        return oneImageView
    }()
    
    lazy var serviceLabel: UILabel = {
        let serviceLabel = UILabel()
        serviceLabel.textAlignment = .left
        serviceLabel.text = LanguageManager.localizedString(for: "My Service")
        serviceLabel.textColor = UIColor.init(hexString: "#333333")
        serviceLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(900))
        return serviceLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(appHeadView)
        appHeadView.configTitle(with: LanguageManager.localizedString(for: "Personal Center"))
        appHeadView.backBtn.isHidden = true
        appHeadView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
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
        oneImageView.snp.makeConstraints { make in
            make.top.equalTo(pImageView.snp.bottom).offset(16)
            make.size.equalTo(CGSize(width: 343.pix(), height: 102.pix()))
            make.centerX.equalToSuperview()
        }
        
        scrollView.addSubview(serviceLabel)
        serviceLabel.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16.pix())
            make.height.equalTo(19)
        }
        
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.centerInfo()
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.centerInfo()
        }
    }
    
    private func createButtons(with modelArray: [certainlyModel]) {
        buttonContainerView?.removeFromSuperview()
        
        if modelArray.isEmpty {
            return
        }
        
        let container = UIView()
        container.backgroundColor = .clear
        scrollView.addSubview(container)
        buttonContainerView = container
        
        container.snp.makeConstraints { make in
            make.top.equalTo(serviceLabel.snp.bottom).offset(10.pix())
            make.left.equalToSuperview().offset(16.pix())
            make.centerX.equalToSuperview()
        }
        
        let buttonSize: CGFloat = 110.pix()
        let columns: Int = 3
        let spacing: CGFloat = (SCREEN_WIDTH - 362.pix()) * 0.5
        
        var listViews: [MineListView] = []
        
        for (index, model) in modelArray.enumerated() {
            let row = index / columns
            let column = index % columns
            
            let listView = MineListView(frame: .zero)
            listView.model = model
            container.addSubview(listView)
            listViews.append(listView)
            
            listView.tapBlock = { [weak self] model in
                guard let self = self else { return }
                let pageUrl = model.stated ?? ""
                if pageUrl.isEmpty {
                    return
                }
                if pageUrl.contains(DeepLinkRoute.scheme_url) {
                    URLSchemeRouter.handle(pageURL: pageUrl, from: self)
                }else {
                    self.goWordWebVc(with: pageUrl)
                }
            }
            
            listView.snp.makeConstraints { make in
                make.width.height.equalTo(buttonSize)
                
                if row == 0 {
                    make.top.equalToSuperview()
                } else {
                    let buttonAbove = listViews[index - columns]
                    make.top.equalTo(buttonAbove.snp.bottom).offset(10.pix())
                }
                
                if column == 0 {
                    make.left.equalToSuperview()
                } else {
                    let previousButton = listViews[index - 1]
                    make.left.equalTo(previousButton.snp.right).offset(spacing)
                }
                
                if index == modelArray.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
        }
        
        let rows = ceil(CGFloat(modelArray.count) / CGFloat(columns))
        let containerHeight = rows * (buttonSize + 10.pix()) - 10.pix()
        
        container.snp.remakeConstraints { make in
            make.top.equalTo(serviceLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16.pix())
            make.centerX.equalToSuperview()
            make.height.equalTo(containerHeight)
        }
        
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            let contentHeight = container.frame.maxY + 20
            self.scrollView.contentSize = CGSize(
                width: self.view.frame.width,
                height: max(contentHeight, self.scrollView.frame.height + 1)
            )
        }
    }
    
}

extension MineViewController {
    
    private func centerInfo() async {
        do {
            let parameters = ["migraines": UserDataManager.getPhone() ?? ""]
            let model = try await viewModel.centerMineApi(parameters: parameters)
            if model.illness == 0 {
                let phone = model.potions?.userInfo?.purported ?? ""
                self.phoneLabel.text = phone
                UserDefaults.standard.set(phone, forKey: "user_c_phone")
                UserDefaults.standard.synchronize()
                let modelArray = model.potions?.certainly ?? []
                DispatchQueue.main.async {
                    self.createButtons(with: modelArray)
                }
            }
            await self.scrollView.mj_header?.endRefreshing()
        } catch {
            await self.scrollView.mj_header?.endRefreshing()
        }
    }
}


