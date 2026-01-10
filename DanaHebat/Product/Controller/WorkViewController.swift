//
//  WorkViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import SnapKit
import MJRefresh
import RxSwift
import RxCocoa
import TYAlertController

class WorkViewController: BaseViewController {
    
    var productID: String = ""
    
    var orderID: String = ""
    
    var appTitle: String = ""
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = HttpViewModel()
    
    var listModelArray: [showedModel] = []
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "log_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.setTitle(LanguageManager.localizedString(for: "Next"), for: .normal)
        applyBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(600))
        applyBtn.setBackgroundImage(UIImage(named: "guide_btn_image"), for: .normal)
        return applyBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80.pix()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TapClickViewCell.self,
                           forCellReuseIdentifier: "TapClickViewCell")
        tableView.register(EnterWordViewCell.self,
                           forCellReuseIdentifier: "EnterWordViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(appHeadView)
        appHeadView.configTitle(with: appTitle)
        appHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        appHeadView.backBlock = { [weak self] in
            guard let self = self else { return }
            self.backProductVc()
        }
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(applyBtn)
        applyBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30.pix())
            make.size.equalTo(CGSize(width: 299.pix(), height: 46.pix()))
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(applyBtn.snp.top).offset(-10.pix())
        }
        
        applyBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                var parameters = ["will": productID]
                for model in listModelArray {
                    let key = model.illness ?? ""
                    let almost = model.almost ?? ""
                    let orthoreoviruses = model.orthoreoviruses ?? ""
                    var value = ""
                    if almost.isEmpty {
                        value = orthoreoviruses
                    }else {
                        value = almost
                    }
                    parameters[key] = value
                }
                Task {
                    await self.savePerInfo(with: parameters)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.getPerInfo()
        }
    }
}

extension WorkViewController {
    
    private func getPerInfo() async {
        do {
            let parameters = ["will": productID]
            let model = try await viewModel.getWorkApi(parameters: parameters)
            if model.illness == 0 {
                let modelArray = model.potions?.showed ?? []
                self.listModelArray = modelArray
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    private func savePerInfo(with parameters: [String: String]) async {
        do {
            let model = try await viewModel.saveWorkApi(parameters: parameters)
            if model.illness == 0 {
                self.backProductVc()
            }else {
                ToastManager.showMessage(model.mental ?? "")
            }
        } catch {
            
        }
    }
    
}

extension WorkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.listModelArray[indexPath.row]
        let type = model.analyses ?? ""
        if type == "genusb" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EnterWordViewCell", for: indexPath) as! EnterWordViewCell
            cell.model = model
            cell.enterTextChanged = { text in
                model.orthoreoviruses = text
                model.almost = text
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TapClickViewCell", for: indexPath) as! TapClickViewCell
            cell.model = model
            cell.tapCellBlock = { [weak self] listModel in
                guard let self = self else { return }
                self.tapClickCell(with: listModel, cell: cell)
            }
            return cell
        }
        
    }
    
}

extension WorkViewController {
    
    private func tapClickCell(with model: showedModel, cell: TapClickViewCell) {
        let alertView = PersonalEnumView(frame: view.bounds)
        
        alertView.nameLabel.text = model.infected ?? ""
        
        let modelArray = model.linked ?? []
        
        alertView.modelArray = modelArray
        
        if let selectedValue = cell.codeFiled.text,
           let selectedIndex = modelArray.firstIndex(where: { $0.crawl == selectedValue }) {
            alertView.selectedIndex = selectedIndex
        }
        
        let alertVc = TYAlertController(alert: alertView, preferredStyle: .alert)
        self.present(alertVc!, animated: true)
        
        alertView.leftBlock = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        alertView.rightBlock = { [weak self] listModel in
            guard let self = self else { return }
            self.dismiss(animated: true)
            cell.codeFiled.text = listModel.crawl ?? ""
            model.orthoreoviruses = listModel.crawl ?? ""
            model.almost = listModel.almost ?? ""
        }
        
    }
    
}
