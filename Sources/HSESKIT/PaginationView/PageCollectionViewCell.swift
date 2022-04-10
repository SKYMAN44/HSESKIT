//
//  PageCollectionViewCell.swift
//  
//
//  Created by Дмитрий Соколов on 22.02.2022.
//

import UIKit

final class PageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SegmentCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.body)()
        label.textColor = .textAndIcons.style(.secondary)()
        label.textAlignment = .center
        
        return label
    }()
    
    private let notificationView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .background.style(.accent)()
        
        return view
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.caption)()
        label.textColor = .textAndIcons.style(.secondary)()
        label.textAlignment = .center
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if(isSelected) {
                self.backgroundColor = .primary.style(.filler)()
                self.titleLabel.textColor = .primary.style(.primary)()
                notificationView.backgroundColor = .background.style(.firstLevel)()
            }else {
                notificationView.backgroundColor = .background.style(.accent)()
                self.backgroundColor = .background.style(.firstLevel)()
                self.titleLabel.textColor = .textAndIcons.style(.secondary)()
            }
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
        
        notificationView.addSubview(notificationLabel)
        
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let notificationConstrains = [
            notificationLabel.leadingAnchor.constraint(equalTo: notificationView.leadingAnchor, constant: 8),
            notificationLabel.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor, constant: -8),
            notificationLabel.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 4),
            notificationLabel.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: -4)
        ]
        
        NSLayoutConstraint.activate(notificationConstrains)
        
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, notificationView])
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.axis = .horizontal
        
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewConstrains = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ]
        
        NSLayoutConstraint.activate(stackViewConstrains)
    }
    
    // MARK: - External call
    public func configure(item: PageItem) {
        titleLabel.text = item.title
        guard item.notifications != 0
        else {
            notificationView.isHidden = true
            return
        }
        notificationView.isHidden = false
        notificationLabel.text = String(item.notifications)
    }
    
    
}
