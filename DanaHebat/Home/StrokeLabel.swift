//
//  StrokeLabel.swift
//  DanaHebat
//
//  Created by hekang on 2026/1/10.
//

import UIKit

class StrokeLabel: UILabel {
    var strokeWidth: CGFloat = 2.0
    var strokeColor: UIColor = UIColor(hexString: "#0329F6")
    
    override var text: String? {
        didSet {
            updateStrokeText()
        }
    }
    
    override var textColor: UIColor? {
        didSet {
            updateStrokeText()
        }
    }
    
    override var font: UIFont! {
        didSet {
            updateStrokeText()
        }
    }
    
    private func updateStrokeText() {
        guard let text = self.text else {
            self.attributedText = nil
            return
        }
        
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: strokeColor,
            .strokeWidth: -strokeWidth,
            .foregroundColor: textColor ?? .white,
            .font: font ?? UIFont.systemFont(ofSize: 18)
        ]
        
        self.attributedText = NSAttributedString(string: text, attributes: strokeTextAttributes)
    }
}

