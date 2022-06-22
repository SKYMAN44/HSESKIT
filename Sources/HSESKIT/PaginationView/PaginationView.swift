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
    func addItemChosen()
}

public class PaginationView: UIView {
    public enum Mode {
        case read
        case edit
    }

    private var mode: Mode
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
    public init(_ mode: Mode) {
        self.mode = mode
        super.init(frame: .zero)
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        self.mode = .read
        super.init(coder: coder)
        
        
        setupCollectionView()
    }

    // MARK: - UI setup
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 5, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 12
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = self.backgroundColor
        
        collectionView?.register(
            PageCollectionViewCell.self,
            forCellWithReuseIdentifier: PageCollectionViewCell.reuseIdentifier
        )
        collectionView?.register(
            PageAddCollectionViewCell.self,
            forCellWithReuseIdentifier: PageAddCollectionViewCell.reuseIdentifier
        )
        
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
            if let item = self.collectionView?.cellForItem(at: IndexPath(row: 0, section: 0)) {
                self.collectionView?.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
        }
    }
    
    /// scroll to specified segment
    public func moveTo(_ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if let item = collectionView?.cellForItem(at: indexPath) {
            collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
}

// MARK: - CollectionView Delegate
extension PaginationView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.segmentChosen(index: indexPath.row)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.cellForItem(at: indexPath) is PageAddCollectionViewCell {
            delegate?.addItemChosen()
            return false
        }
        return true
    }
}

// MARK: - CollectionView DataSource
extension PaginationView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  mode == .edit ? segmentItems.count + 1 : segmentItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == segmentItems.count) {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PageAddCollectionViewCell.reuseIdentifier,
                for: indexPath
            )
            return cell
        }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PageCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! PageCollectionViewCell
        cell.configure(item: segmentItems[indexPath.row])
        
        return cell
    }
}
