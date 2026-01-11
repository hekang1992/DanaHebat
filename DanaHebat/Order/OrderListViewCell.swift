//
//  OrderListViewCell.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import UIKit
import SnapKit

class OrderListViewCell: UITableViewCell {

    var model: certainlyModel? {
        didSet {
            guard let model = model else { return }
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "od_o_a_image")
        bgImageView.contentMode = .scaleAspectFit
        return bgImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 343.pix(), height: 225.pix()))
            make.bottom.equalToSuperview().offset(-11.pix())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
