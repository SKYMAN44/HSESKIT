//
//  File.swift
//  
//
//  Created by Дмитрий Соколов on 22.02.2022.
//

import Foundation
import UIKit

final class SegmentedControl: UIControl {
    private var buttons = [UIButton]()
    private var selector: UIView!
    private(set) var selectedSegmentIndex = 0
    
    public var borderWidth: CGFloat = 0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    public var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    /// provide values for segments as comma-separated words in String type
    ///  example: "Schedule,Deadline"
    public var titlesCS: String = "" {
        didSet{
            updateView()
        }
    }
    
    public var textColor: UIColor = .systemGray6 {
        didSet {
            updateView()
        }
    }
    
    public var selectorColor: UIColor = .blue {
        didSet {
            updateView()
        }
    }
    
    public var selectorTextColor: UIColor = .blue {
        didSet {
            updateView()
        }
    }
    
    public var textFont: UIFont = .systemFont(ofSize: 16) {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        buttons.removeAll()
        subviews.forEach({ $0.removeFromSuperview()})
        
        let titles = titlesCS.components(separatedBy: ",")
        
        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = textFont
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        selector = UIView(frame: CGRect(x: 0, y: 0, width: frame.width / CGFloat(buttons.count), height: frame.height))
        selector.layer.cornerRadius = 8
        selector.backgroundColor = selectorColor
        selector.alpha = 0.5
        addSubview(selector)
        
        selector.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selector.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            selector.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }

    override func draw(_ rect: CGRect) {
        
    }
    
    @objc
    private func buttonTapped(button: UIButton) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        for (bIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if(btn == button) {
                selectedSegmentIndex = bIndex
                UIView.animate(withDuration: 0.3) {
                    self.selector.frame.origin.x = self.frame.width / CGFloat(self.buttons.count) * CGFloat(bIndex)
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        sendActions(for: .valueChanged)
    }
}
