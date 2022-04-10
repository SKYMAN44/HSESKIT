//
//  DropNavigationBar.swift
// 
//
//  Created by Дмитрий Соколов on 10.04.2022.
//

import UIKit

public class DropNavigationBar: UIControl {
    
    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addConstraint(NSLayoutConstraint (
            item: button,
            attribute: .height,
            relatedBy: .equal,
            toItem: button,
            attribute: .width,
            multiplier: 1,
            constant: 0
        ))
        button.addTarget(self, action: #selector(rightButtonTappd(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private let indicatorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "chevron-down"))
        imageView.contentMode = .center
        imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        return imageView
    }()
    
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "TimeTable"
        label.font = .customFont.style(.title)()
        label.textColor = .textAndIcons.style(.primary)()
        label.textAlignment = .center
        
        return label
    }()
    
    private var minorLabel: UILabel = {
        let label = UILabel()
        label.text = "Assigments"
        label.font = .customFont.style(.title)()
        label.textColor = .textAndIcons.style(.primary) ()
        label.textAlignment = .center
        
        return label
    }()
    
    private let mainButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var slidingButton = UIButton()
    private let mainView = UIView()
    private let slidingView = UIView()
    private let labelsMainView = UIView()
    private var slideViewIsVisible: Bool = false
    private var animationCompleted: Bool = true
    private var closedHeightConstraint: NSLayoutConstraint?
    
    
    // MARK: - public setters
    public var navBackgroundColor: UIColor? {
        didSet {
            mainView.backgroundColor = navBackgroundColor
            slidingView.backgroundColor = navBackgroundColor
            mainLabel.backgroundColor = navBackgroundColor
            minorLabel.backgroundColor = navBackgroundColor
        }
    }
    
    public var navTintColor: UIColor? {
        didSet {
            rightButton.tintColor = navTintColor
            mainLabel.textColor = navTintColor
            minorLabel.textColor = navTintColor
            indicatorImageView.tintColor = navTintColor
        }
    }
    
    public var rightItemImage = UIImage(named: "calendarCS") {
        didSet {
            rightButton.setImage(rightItemImage, for: .normal)
        }
    }
    
    public var firstText: String = "#1" {
        didSet {
            mainLabel.text = firstText
        }
    }
    
    public var secondText: String = "#2" {
        didSet {
            minorLabel.text = secondText
        }
    }
    
    public var textFont: UIFont = .customFont.style(.title)() {
        didSet {
            mainLabel.font = textFont
            minorLabel.font = textFont
        }
    }
    
    public var closedHeight: Double = 60.0  {
        didSet {
            closedHeightConstraint?.constant = closedHeight
            slidingView.frame = CGRect(
                origin: slidingView.frame.origin,
                size: CGSize(
                    width: slidingView.frame.width,
                    height: slidingView.frame.height
                )
            )
        }
    }
    
    public var hegihtConstraintReference: NSLayoutConstraint?
    
    // MARK: - getters
    /// returns currently chosen segment (0 or 1)
    public private(set) var choosenSegment = 0
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func setupView() {
        setupMainView()
    }
    
    private func setupMainView() {
        addSubview(slidingView)
        addSubview(mainView)
        
        slidingView.frame = CGRect(x: 0, y: 0, width: ScreenSize.Width, height: closedHeight - 2)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor),
            mainView.leftAnchor.constraint(equalTo: self.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        closedHeightConstraint = mainView.heightAnchor.constraint(equalToConstant: closedHeight)
        closedHeightConstraint?.isActive = true
        
        mainView.addSubview(rightButton)
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -15).isActive = true
        rightButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        
        setupSlidingView()
    }
    
    private func setupSlidingView() {
        let sV = UIStackView(arrangedSubviews: [labelsMainView, indicatorImageView])
        sV.distribution = .fill
        sV.alignment = .fill
        sV.axis = .horizontal
        sV.spacing = 0
        
        mainView.addSubview(sV)
        mainView.addSubview(mainButton)
        
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        
        mainButton.rightAnchor.constraint(equalTo: sV.rightAnchor).isActive = true
        mainButton.topAnchor.constraint(equalTo: sV.topAnchor).isActive = true
        mainButton.bottomAnchor.constraint(equalTo: sV.bottomAnchor).isActive = true
        mainButton.leftAnchor.constraint(equalTo: sV.leftAnchor).isActive = true
        
        sV.translatesAutoresizingMaskIntoConstraints = false
        sV.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        sV.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        sV.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 1/3).isActive = true
        sV.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.8).isActive = true
        
        labelsMainView.addSubview(minorLabel)
        labelsMainView.addSubview(mainLabel)
        
        minorLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mainLabel.centerXAnchor.constraint(equalTo: labelsMainView.centerXAnchor).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: labelsMainView.centerYAnchor).isActive = true
        mainLabel.widthAnchor.constraint(equalTo: labelsMainView.widthAnchor, multiplier: 1).isActive = true
        mainLabel.heightAnchor.constraint(equalTo: labelsMainView.heightAnchor, multiplier: 1).isActive = true

        minorLabel.centerXAnchor.constraint(equalTo: labelsMainView.centerXAnchor).isActive = true
        minorLabel.centerYAnchor.constraint(equalTo: labelsMainView.centerYAnchor).isActive = true
        minorLabel.widthAnchor.constraint(equalTo: labelsMainView.widthAnchor, multiplier: 1).isActive = true
        minorLabel.heightAnchor.constraint(equalTo: labelsMainView.heightAnchor, multiplier: 1).isActive = true
        
        setupSlidingButton()
    }
    
    private func setupSlidingButton() {
        slidingButton.addTarget(self, action: #selector(self.slidedButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Interactions
    @objc
    private func rightButtonTappd(_ button: UIButton) {
        sendActions(for: .touchUpInside)
    }
    
    @objc
    private func buttonTapped() {
        guard animationCompleted else { return }
        
        if(slideViewIsVisible) {
            animationCompleted = false
            slideViewIsVisible = false
            slidingButton.removeFromSuperview()
            minorLabel.layer.zPosition = 0
            hideAnimation {
                self.animationCompleted = true
                self.hegihtConstraintReference?.constant = self.closedHeight
            }
        } else {
            animationCompleted = false
            UIView.animate(withDuration: 0.3, animations: {
                self.slidingView.frame.origin.y = self.mainView.frame.height
                self.indicatorImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            })
            UIView.animate(withDuration: 0.3, delay: 0.01, animations: {
                self.minorLabel.frame.origin.y = self.labelsMainView.frame.height
            }) { _ in
                self.minorLabel.layer.zPosition = 1
                self.slideViewIsVisible = true
                self.hegihtConstraintReference?.constant = self.mainView.frame.height + self.slidingView.frame.height
                self.addSubview(self.slidingButton)
                self.slidingButton.frame = self.slidingView.frame
                
                self.animationCompleted = true
            }
        }
    }
    
    @objc
    private func slidedButtonTapped() {
        guard animationCompleted else { return }
        
        animationCompleted = false
        slidingButton.removeFromSuperview()
        self.minorLabel.layer.zPosition = 1
        self.mainLabel.layer.zPosition = 0
        
        hideAnimation {
            self.animationCompleted = true
            if(self.choosenSegment == 0) {
                self.choosenSegment = 1
            } else {
                self.choosenSegment = 0
            }
            self.hegihtConstraintReference?.constant = self.closedHeight
            self.sendActions(for: .valueChanged)
        }
        
        let temp = mainLabel
        mainLabel = minorLabel
        minorLabel = temp
        slideViewIsVisible = false
    }
    
    // MARK: - Internal call
    public func hide() {
        guard animationCompleted else { return }

        if(slideViewIsVisible) {
            animationCompleted = false
            slideViewIsVisible = false
            slidingButton.removeFromSuperview()
            minorLabel.layer.zPosition = 0
            hideAnimation {
                self.animationCompleted = true
                self.hegihtConstraintReference?.constant = self.closedHeight
            }
        }
    }
    
    // helper function
    private func hideAnimation(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3, animations: {
            self.minorLabel.frame.origin.y = 0
            self.indicatorImageView.transform = CGAffineTransform.identity
        })
        UIView.animate(withDuration: 0.3, delay: 0.01, animations: {
            self.slidingView.frame.origin.y = 0
        }) { _ in
            completion()
        }
    }
}
