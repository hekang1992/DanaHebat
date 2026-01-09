//
//  LoadingIndicator.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//


import UIKit
import SnapKit

final class LoadingIndicator {
    
    // MARK: - Properties
    private static var window: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    private static let backgroundTag = 9999
    private static let contentTag = 9998
    
    // MARK: - Public Methods
    static func show(
        style: UIActivityIndicatorView.Style = .large,
        indicatorColor: UIColor = .systemBlue,
        maskColor: UIColor = UIColor.black.withAlphaComponent(0.3),
        contentColor: UIColor = .white,
        cornerRadius: CGFloat = 12
    ) {
        DispatchQueue.main.async {
            guard let window = window else { return }
            
            let maskView = UIView()
            maskView.backgroundColor = maskColor
            maskView.tag = backgroundTag
            
            let contentView = UIView()
            contentView.backgroundColor = contentColor
            contentView.layer.cornerRadius = cornerRadius
            contentView.layer.masksToBounds = true
            contentView.tag = contentTag
            
            let activityIndicator = UIActivityIndicatorView(style: style)
            activityIndicator.color = indicatorColor
            activityIndicator.startAnimating()
            
            contentView.addSubview(activityIndicator)
            maskView.addSubview(contentView)
            window.addSubview(maskView)
            
            maskView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            let contentSize: CGFloat = style == .large ? 80 : 60
            contentView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(contentSize)
            }
            
            activityIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            window?.subviews.forEach { view in
                if view.tag == backgroundTag || view.tag == contentTag {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
}
