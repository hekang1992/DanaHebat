//
//  HomeViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MJRefresh
import Kingfisher

class HomeViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = HttpViewModel()
    
    private var baseModel: BaseModel?
    
    private var productModel: newarModel?
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("Log in to Zoom Loan", for: .normal)
        loginBtn.setTitleColor(.black, for: .normal)
        return loginBtn
    }()
    
    lazy var headView: HomeHeadView = {
        let headView = HomeHeadView(frame: .zero)
        return headView
    }()
    
    lazy var homeView: HomeView = {
        let homeView = HomeView(frame: .zero)
        homeView.isHidden = true
        return homeView
    }()
    
    lazy var homeListView: HomeProductListView = {
        let homeListView = HomeProductListView(frame: .zero)
        homeListView.isHidden = true
        return homeListView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        view.addSubview(homeView)
        homeView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(homeListView)
        homeListView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        headView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            self.changeCenterRootVc()
        }
        
        homeView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.homeInfo()
            }
        })
        
        homeListView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.homeInfo()
            }
        })
        
        homeView.oneBlock = { [weak self] in
            guard let self = self, let productModel = productModel else { return }
            if UserDataManager.isLoggedIn() {
                Task {
                    let productID = String(productModel.anthropologist ?? 0)
                    await self.enterInfo(with: productID)
                }
            }else {
                let loginVc = BaseNavigationController(rootViewController: LoginViewController())
                loginVc.modalPresentationStyle = .fullScreen
                self.present(loginVc, animated: true)
            }
            
        }
        
        homeListView.cellBlock = { [weak self] model in
            guard let self = self else { return }
            Task {
                let productID = String(model.anthropologist ?? 0)
                await self.enterInfo(with: productID)
            }
        }
        
        homeView.twoBlock = { [weak self] in
            guard let self = self else { return }
            let loanVc = LoanDetailViewController()
            self.navigationController?.pushViewController(loanVc, animated: true)
        }
        
        homeView.threeBlock = { [weak self] in
            guard let self = self, let baseModel = baseModel else { return }
            let pageUrl = baseModel.potions?.off?.ready ?? ""
            self.goWordWebVc(with: pageUrl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.homeInfo()
        }
    }
    
}

extension HomeViewController {
    
    private func homeInfo() async {
        do {
            let parameters = ["purported": UserDataManager.getPhone() ?? ""]
            let model = try await viewModel.homeApi(parameters: parameters)
            self.baseModel = model
            if model.illness == 0 {
                var modelArray = model.potions?.certainly ?? []
                if let listModel = modelArray.first(where: { $0.almost == "lengthsb" }) {
                    let newarModel = listModel.newar?.first ?? newarModel()
                    self.productModel = newarModel
                    self.configHeadInfo(with: newarModel)
                    self.homeView.model = newarModel
                    self.homeView.isHidden = false
                    self.homeListView.isHidden = true
                }else {
                    
                    if let index = modelArray.firstIndex(where: { $0.almost == "lengthsa" }) {
                        modelArray.remove(at: index)
                    }
                    
                    if let listModel = modelArray.first(where: { $0.almost == "lengthsc" }) {
                        let newarModel = listModel.newar?.first ?? newarModel()
                        self.configHeadInfo(with: newarModel)
                    }
                    
                    self.homeListView.modelArray = modelArray
                    self.homeView.isHidden = true
                    self.homeListView.isHidden = false
                }
            }
            await MainActor.run {
                self.homeView.scrollView.mj_header?.endRefreshing()
                self.homeListView.tableView.mj_header?.endRefreshing()
            }
        } catch {
            await MainActor.run {
                self.homeView.scrollView.mj_header?.endRefreshing()
                self.homeListView.tableView.mj_header?.endRefreshing()
            }
        }
    }
    
    func configHeadInfo(with model: newarModel) {
        let logoUrl = model.asthma ?? ""
        self.headView.nameLabel.text = model.ecological ?? ""
        self.headView.logoImageView.kf.setImage(with: URL(string: logoUrl))
    }
    
}

extension HomeViewController {
    
    private func enterInfo(with productID: String) async {
        do {
            let parameters = ["will": productID]
            let model = try await viewModel.enterApi(parameters: parameters)
            if model.illness == 0 {
                let pageUrl = model.potions?.stated ?? ""
                if pageUrl.isEmpty {
                    return
                }
                if pageUrl.hasPrefix(DeepLinkRoute.scheme_url) {
                    URLSchemeRouter.handle(pageURL: pageUrl, from: self)
                }else {
                    self.goWordWebVc(with: pageUrl)
                }
            }else {
                ToastManager.showMessage(model.mental ?? "")
            }
        } catch {
            
        }
    }
    
}
