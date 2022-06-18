//
//  File.swift
//  
//
//  Created by Дмитрий Соколов on 18.06.2022.
//

import UIKit

final class PageAddCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PageAddCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clearPlusIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .textAndIcons.style(.secondary)()

        return imageView
    }()

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

        self.heightAnchor.constraint(equalToConstant: 36).isActive = true
        self.widthAnchor.constraint(equalToConstant: 36).isActive = true

        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 13),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13)
        ])
    }
}
