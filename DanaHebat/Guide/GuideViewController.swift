//
//  GuideViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit
import SnapKit
import AppTrackingTransparency

class GuideViewController: BaseViewController {
    
    private let viewModel = HttpViewModel()
    
    private var scrollView: UIScrollView!
    
    private var nextButton: UIButton!
    
    private var currentPage: Int = 0
    
    private let backgroundENImageNames = ["guide_en_one_image", "guide_en_two_image"]
    
    private let backgroundIDImageNames = ["guide_id_one_image", "guide_id_two_image"]
    
    private var backgroundImageNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        let code = LanguageManager.shared.getCurrentLanguageCode()
        backgroundImageNames = code == 2 ? backgroundENImageNames : backgroundIDImageNames
        
        setupScrollView()
        setupButton()
        
        Task {
            await self.getAppIDFA()
        }
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        let pageWidth = view.bounds.width
        let pageHeight = view.bounds.height
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(backgroundImageNames.count),
                                        height: pageHeight)
        
        for (index, imageName) in backgroundImageNames.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: pageWidth * CGFloat(index),
                                                      y: 0,
                                                      width: pageWidth,
                                                      height: pageHeight))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: imageName)
            scrollView.addSubview(imageView)
        }
    }
    
    private func setupButton() {
        nextButton = UIButton(type: .system)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        nextButton.setBackgroundImage(UIImage(named: "guide_btn_image"), for: .normal)
        nextButton.setTitle(LanguageManager.localizedString(for: "Next"), for: .normal)
        nextButton.adjustsImageWhenHighlighted = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(50)
            make.size.equalTo(CGSize(width: 299, height: 46))
        }
    }
    
    @objc private func nextButtonTapped() {
        if currentPage < backgroundImageNames.count - 1 {
            let nextPage = currentPage + 1
            let offsetX = CGFloat(nextPage) * view.bounds.width
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            currentPage = nextPage
        } else {
            SaveGuideShowManager.markAsShown()
            self.changeRootVc()
        }
    }
    
    private func updateButtonTitle() {
        if currentPage == backgroundImageNames.count - 1 {
            nextButton.setTitle(LanguageManager.localizedString(for: "Enter"), for: .normal)
        } else {
            nextButton.setTitle(LanguageManager.localizedString(for: "Next"), for: .normal)
        }
    }
}

extension GuideViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        
        self.currentPage = currentPage
        
        updateButtonTitle()
    }
}

extension GuideViewController {
    
    private func getAppIDFA() async {
        guard #available(iOS 14, *) else { return }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        let status = await ATTrackingManager.requestTrackingAuthorization()
        
        switch status {
        case .authorized, .denied, .notDetermined:
            await uploadIDFAInfo()
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    private func uploadIDFAInfo() async {
        do {
            let parameters = ["forested": DeviceIDManager.getIDFV(),
                              "occur": DeviceIDManager.getIDFA()]
            _ = try await viewModel.uploadIDFAApi(parameters: parameters)
        } catch {
            
        }
    }
    
}

class SaveGuideShowManager {
    
    private static let guideShownKey = "guideShownKey"
    
    static func checkIfGuideShown() -> String {
        let hasShown = UserDefaults.standard.bool(forKey: guideShownKey)
        return hasShown ? "1" : "0"
    }
    
    static func markAsShown() {
        UserDefaults.standard.set(true, forKey: guideShownKey)
        UserDefaults.standard.synchronize()
    }
    
    static func resetGuideShown() {
        UserDefaults.standard.set(false, forKey: guideShownKey)
        UserDefaults.standard.synchronize()
    }
    
}
