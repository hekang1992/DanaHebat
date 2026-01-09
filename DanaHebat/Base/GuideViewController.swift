//
//  GuideViewController.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/9.
//

import UIKit

class GuideViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var nextButton: UIButton!
    private var currentPage: Int = 0
    
    private let backgroundENImageNames = ["guide_en_one_image", "guide_en_two_image"]
    private let backgroundIDImageNames = ["guide_id_one_image", "guide_id_two_image"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupScrollView()
        setupButton()
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
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(backgroundENImageNames.count),
                                        height: pageHeight)
        
        for (index, imageName) in backgroundENImageNames.enumerated() {
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
        nextButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        nextButton.backgroundColor = .white
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        nextButton.layer.cornerRadius = 25
        nextButton.clipsToBounds = true
        nextButton.setTitle("下一步", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        
        nextButton.center = CGPoint(x: view.center.x, y: view.bounds.height - 100)
    }
    
    @objc private func nextButtonTapped() {
        if currentPage < backgroundImageNames.count - 1 {
            let nextPage = currentPage + 1
            let offsetX = CGFloat(nextPage) * view.bounds.width
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            currentPage = nextPage
        } else {
            goToHomePage()
        }
    }
    
    private func goToHomePage() {
        
    }
    
    private func updateButtonTitle() {
        if currentPage == backgroundENImageNames.count - 1 {
            nextButton.setTitle("开始使用", for: .normal)
        } else {
            nextButton.setTitle("下一步", for: .normal)
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
