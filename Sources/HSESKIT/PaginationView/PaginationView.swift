//
//  PaginationView.swift
//  
//
//  Created by Дмитрий Соколов on 22.02.2022.
//

import UIKit

public protocol PaginationViewDelegate: AnyObject {
    /// called by segmentView when chosen segment has changed
    func segmentChosen(index: Int)
}

public class PaginationView: UIView {
    private var collectionView: UICollectionView?
    
    /// segmentView delegate
    public weak var delegate: PaginationViewDelegate?
    
    /// current segment items
    public private(set) var segmentItems: [PageItem] = []
    
    public override var backgroundColor: UIColor? {
        didSet {
            collectionView?.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 5, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 12
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = self.backgroundColor
        
        collectionView?.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: PageCollectionViewCell.reuseIdentifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        self.addSubview(collectionView!)
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: - API
    /// set titles in segments
    public func setTitles(titles: [PageItem]) {
        segmentItems.removeAll()
        segmentItems = titles
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.collectionView?.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
    /// scroll to specified segment
    public func moveTo(_ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
}

// MARK: - CollectionView Delegate
extension PaginationView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.segmentChosen(index: indexPath.row)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - CollectionView DataSource
extension PaginationView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.reuseIdentifier, for: indexPath) as! PageCollectionViewCell
        cell.configure(item: segmentItems[indexPath.row])
        
        return cell
    }
}
