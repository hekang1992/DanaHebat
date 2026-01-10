//
//  ProductViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit

class ProductViewController: BaseViewController {
    
    var productID: String = ""
    
    var orderID: String = ""
    
    var yetModel: yetModel?
    
    private let viewModel = HttpViewModel()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "log_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var productView: ProductView = {
        let productView = ProductView(frame: .zero)
        return productView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(appHeadView)
        appHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        appHeadView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(productView)
        productView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.detailInfo()
        }
    }
    
}

extension ProductViewController {
    
    private func detailInfo() async {
        do {
            let parameters = ["will": productID,
                              "purported": UserDataManager.getPhone() ?? ""]
            let model = try await viewModel.productDetailApi(parameters: parameters)
            if model.illness == 0 {
                self.productView.model = model
                if let yetModel = model.potions?.yet {
                    self.yetModel = yetModel
                    self.configInfo(with: yetModel)
                }
            }
        } catch {
            
        }
    }
    
    private func configInfo(with model: yetModel) {
        self.appHeadView.configTitle(with: model.ecological ?? "")
        self.productView.oneLabel.text = model.indicates ?? ""
        self.productView.twoLabel.text = model.origins ?? ""
        self.productView.oneListView.oneLabel.text = model.aselliscus?.blasii?.tightly ?? ""
        self.productView.oneListView.twoLabel.text = model.aselliscus?.blasii?.involved ?? ""
        self.productView.twoListView.oneLabel.text = model.aselliscus?.affinis?.tightly ?? ""
        self.productView.twoListView.twoLabel.text = model.aselliscus?.affinis?.involved ?? ""
        self.productView.applyBtn.setTitle(model.treat ?? "", for: .normal)
    }
    
}
