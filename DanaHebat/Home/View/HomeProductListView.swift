//
//  HomeProductListView.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import UIKit
import SnapKit

class HomeProductListView: UIView {
    
    var cellBlock: ((newarModel) -> Void)?
    
    var modelArray: [certainlyModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
            tableView.reloadData()
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "log_bg_image")
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80.pix()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HomeProductHeadViewCell.self, forCellReuseIdentifier: "HomeProductHeadViewCell")
        tableView.register(HomeProductListViewCell.self, forCellReuseIdentifier: "HomeProductListViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(tableView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeProductListView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let listArray = modelArray?[section].newar ?? []
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listArray = modelArray?[indexPath.section].newar ?? []
        let type =  modelArray?[indexPath.section].almost ?? ""
        if type == "lengthsc" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductHeadViewCell", for: indexPath) as! HomeProductHeadViewCell
            cell.model = listArray[indexPath.row]
            return cell
        }else if type == "lengthsd" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductListViewCell", for: indexPath) as! HomeProductListViewCell
            cell.model = listArray[indexPath.row]
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listArray = modelArray?[indexPath.section].newar ?? []
        let model = listArray[indexPath.row]
        self.cellBlock?(model)
    }
    
}
