//
//  PersonalEnumView 2.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//


import UIKit
import SnapKit
import RxCocoa
import RxSwift

class PersonalEnumView: UIView {
    
    var modelArray: [linkedModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
        }
    }
    
    var selectedIndex: Int? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedModel: linkedModel? {
        guard let index = selectedIndex,
              let models = modelArray,
              index >= 0 && index < models.count else {
            return nil
        }
        return models[index]
    }
    
    private let disposeBag = DisposeBag()
    
    var leftBlock: (() -> Void)?
    
    var rightBlock: ((linkedModel) -> Void)?
    
    private let selectedColor = UIColor(hexString: "#C0FFEC")
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = LanguageManager.shared.getCurrentLocaleCode() == "id" ? UIImage(named: "alt_enum_d_image") : UIImage(named: "alt_enum_p_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton(type: .custom)
        return leftBtn
    }()
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton(type: .custom)
        return rightBtn
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.init(hexString: "#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 46.pix()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(leftBtn)
        bgImageView.addSubview(rightBtn)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(tableView)
        bgImageView.addSubview(tableView)
        
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 325.pix(), height: 497.pix()))
        }
        leftBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 157.pix(), height: 60.pix()))
        }
        rightBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 157.pix(), height: 60.pix()))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(44.pix())
            make.height.equalTo(25.pix())
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30.pix())
            make.top.equalTo(nameLabel.snp.bottom).offset(25.pix())
            make.bottom.equalToSuperview().offset(-90.pix())
        }
        
        leftBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.leftBlock?()
            })
            .disposed(by: disposeBag)
        
        rightBtn
            .rx
            .tap
            .debounce(.milliseconds(250), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self, let selectedModel = selectedModel else {
                    ToastManager.showMessage(LanguageManager.localizedString(for: "Please select one"))
                    return
                }
                self.rightBlock?(selectedModel)
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PersonalEnumView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(600))
        
        let model = self.modelArray?[indexPath.row]
        cell.textLabel?.text = model?.crawl ?? ""
        
        if indexPath.row == selectedIndex {
            cell.contentView.backgroundColor = selectedColor
            cell.contentView.layer.cornerRadius = 8.pix()
            cell.contentView.layer.masksToBounds = true
            cell.textLabel?.textColor = UIColor.init(hexString: "#333333")
        } else {
            cell.contentView.backgroundColor = .clear
            cell.textLabel?.textColor = UIColor.init(hexString: "#333333")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            selectedIndex = nil
        } else {
            selectedIndex = indexPath.row
        }
    }
    
}
