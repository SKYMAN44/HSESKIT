//
//  InputCollectionViewCell.swift
//  
//
//  Created by Дмитрий Соколов on 23.02.2022.
//

import UIKit

import UIKit

protocol InputContentCollectionViewCellDelegate {
    func removeButtonPressed(indexPath: IndexPath)
}

final class InputContentCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "InputContentCollectionViewCell"
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizesSubviews = true
        imageView.layer.cornerRadius = 12
        imageView.clearsContextBeforeDrawing = true
        
        return imageView
    }()
    
    private var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.tintColor = .textAndIcons.style(.primary)()
        button.backgroundColor = .background.style(.firstLevel)()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addConstraint(NSLayoutConstraint(item: button,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: button,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0))
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    public var delegate: InputContentCollectionViewCellDelegate?
    public var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        removeButton.layer.cornerRadius = removeButton.frame.width / 2
    }
    
    private func setupView() {
        self.layer.cornerRadius = 12
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        
        addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            removeButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            removeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        ])
    }
    
    @objc
    private func removeButtonTapped() {
        delegate?.removeButtonPressed(indexPath: indexPath!)
    }
    
    public func configure(image: UIImage) {
        imageView.image = image
    }
}
