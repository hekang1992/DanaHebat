//
//  WordH5WebViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift
import SnapKit
import StoreKit

class WordH5WebViewController: BaseViewController {
    
    var pageUrl: String = ""
    private let disposeBag = DisposeBag()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .clear
        progressView.progressTintColor = .blue
        progressView.isHidden = true
        return progressView
    }()
    
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "PreviouslyFamily")
        userContentController.add(self, name: "RhinolphyllotisRevised")
        userContentController.add(self, name: "LepidusAdded")
        userContentController.add(self, name: "HuntedThe")
        userContentController.add(self, name: "TheThan")
        
        config.userContentController = userContentController
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindRx()
        loadWebView()
    }
    
    private func setupUI() {
        view.addSubview(appHeadView)
        appHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(appHeadView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        webView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        appHeadView.backBlock = { [weak self] in
            guard let self = self else { return }
            if self.webView.canGoBack {
                self.webView.goBack()
            }else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    
    private func bindRx() {
        webView.rx.observe(String.self, "title")
            .distinctUntilChanged()
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                self.appHeadView.nameLabel.text = title
            })
            .disposed(by: disposeBag)
        
        webView.rx.observe(Double.self, "estimatedProgress")
            .distinctUntilChanged()
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] progress in
                guard let self = self else { return }
                self.progressView.progress = Float(progress)
                
                if progress >= 1.0 {
                    UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseInOut, animations: {
                        self.progressView.alpha = 0
                    }, completion: { _ in
                        self.progressView.isHidden = true
                        self.progressView.progress = 0
                    })
                } else {
                    if self.progressView.isHidden {
                        self.progressView.isHidden = false
                        self.progressView.alpha = 1
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func loadWebView() {
        let requestUrl = RequestParamBuilder.buildRequestString(from: pageUrl)
        guard let url = URL(string: requestUrl) else {
            print("Invalid URL: \(pageUrl)")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}

// MARK: - WKNavigationDelegate
extension WordH5WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.progressView.isHidden = true
    }
}

extension WordH5WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "PreviouslyFamily":
            handlePreviouslyFamily(message.body)
        case "RhinolphyllotisRevised":
            handleRhinolphyllotisRevised(message.body as? [String] ?? [])
        case "LepidusAdded":
            handleLepidusAdded(message.body)
        case "HuntedThe":
            handleHuntedThe(message.body)
        case "TheThan":
            handleTheThan(message.body)
        default:
            print("Unknown message name: \(message.name)")
        }
    }
    
    private func handlePreviouslyFamily(_ body: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func handleRhinolphyllotisRevised(_ body: [String]) {
        let pageUrl = body.first ?? ""
        if pageUrl.isEmpty {
            return
        }
        if pageUrl.contains(DeepLinkRoute.scheme_url) {
            URLSchemeRouter.handle(pageURL: pageUrl, from: self)
        }else {
            self.pageUrl = pageUrl
            self.loadWebView()
        }
    }
    
    private func handleLepidusAdded(_ body: Any) {
        self.changeRootVc()
    }
    
    private func handleHuntedThe(_ body: Any) {
        self.toAppStore()
    }
    
    private func handleTheThan(_ body: Any) {
        print("JS调用 TheThan: \(body)")
        // 实现具体的业务逻辑
    }
    
    func toAppStore() {
        guard #available(iOS 14.0, *),
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        SKStoreReviewController.requestReview(in: windowScene)
    }
}


