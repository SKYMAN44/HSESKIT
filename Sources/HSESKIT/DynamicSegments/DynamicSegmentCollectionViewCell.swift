//
//  DynamicSegmentCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.04.2022.
//

import UIKit

class DynamicSegmentCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "DynamicSegmentCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.body)()
        label.textColor = .textAndIcons.style(.secondary)()
        label.textAlignment = .center
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if(isSelected) {
                self.backgroundColor = .primary.style(.filler)()
                self.titleLabel.textColor = .primary.style(.primary)()
            } else {
                self.backgroundColor = .background.style(.firstLevel)()
                self.titleLabel.textColor = self.textColor
            }
        }
    }
    
    private var textColor: UIColor = .textAndIcons.style(.secondary)() {
        didSet {
            titleLabel.textColor = textColor
        }
    }
    
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
        self.backgroundColor = .background.style(.secondLevel)()
        self.layer.cornerRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewConstrains = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ]
        
        NSLayoutConstraint.activate(stackViewConstrains)
    }
    
    public func configure(item: DynamicSegments.Configuration.Item) {
        self.titleLabel.text = item.presentingName
        if(item.isChoosen) {
            self.textColor = .primary.style(.primary)()
        } else {
            self.textColor = .textAndIcons.style(.secondary)()
        }
    }
}
