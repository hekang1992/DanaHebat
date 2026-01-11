//
//  OrderEmptyView.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/11.
//

import UIKit
import SnapKit

class OrderEmptyView: UIView {
    
    var onTap: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = LanguageManager.shared.getCurrentLocaleCode() == "id" ? UIImage(named: "olo_hea_em_image") : UIImage(named: "olo_ehea_em_image")
        bgImageView.contentMode = .scaleAspectFit
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70.pix())
            make.size.equalTo(CGSize(width: 236.pix(), height: 291.pix()))
        }
    }
    
    private func setupTapGesture() {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imageTapGesture.numberOfTapsRequired = 1
        bgImageView.addGestureRecognizer(imageTapGesture)
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}
