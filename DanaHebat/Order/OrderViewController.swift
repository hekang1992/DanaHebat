//
//  OrderViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit
import SnapKit
import MJRefresh

class OrderViewController: BaseViewController {
    
    var type: String = String(Int(1 + 3))
    
    private let viewModel = HttpViewModel()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = languageCode == "id" ? UIImage(named: "olo_hea_image") : UIImage(named: "olo_ehea_image")
        return oneImageView
    }()
    
    lazy var orderView: OrderView = {
        let orderView = OrderView(frame: .zero)
        return orderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(appHeadView)
        appHeadView.configTitle(with: LanguageManager.localizedString(for: "Order Center"))
        appHeadView.backBtn.isHidden = true
        appHeadView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        view.addSubview(oneImageView)
        oneImageView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.size.equalTo(CGSize(width: 375.pix(), height: 123.pix()))
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(orderView)
        orderView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        orderView.tapClickBlock = { [weak self] type in
            guard let self = self else { return }
            self.type = type
            Task {
                await self.orderListInfo(with: type)
            }
        }
        
        orderView.emptyClickBlock = { [weak self] in
            guard let self = self else { return }
            self.changeRootVc()
        }
        
        orderView.cellTapClickBlock = { [weak self] model in
            guard let self = self else { return }
            let pageUrl = model.rocky ?? ""
            if pageUrl.isEmpty {
                return
            }
            if pageUrl.hasPrefix(DeepLinkRoute.scheme_url) {
                URLSchemeRouter.handle(pageURL: pageUrl, from: self)
            }else {
                self.goWordWebVc(with: pageUrl)
            }
        }
        
        orderView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.orderListInfo(with: self.type)
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.orderListInfo(with: type)
        }
    }
    
}

extension OrderViewController {
    
    private func orderListInfo(with type: String) async {
        do {
            let parameters = ["transmitted": type]
            let model = try await viewModel.orderListApi(parameters: parameters)
            if model.illness == 0 {
                let modelArray = model.potions?.certainly ?? []
                self.orderView.modelArray = modelArray
                self.orderView.tableView.reloadData()
            }
            await self.orderView.tableView.mj_header?.endRefreshing()
        } catch {
            await self.orderView.tableView.mj_header?.endRefreshing()
        }
    }
    
}
