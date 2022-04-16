//
//  File.swift
//  
//
//  Created by Дмитрий Соколов on 16.04.2022.
//

import Foundation
import UIKit

// MARK: - Protocol
public protocol DynamicSegmentsDelegate: AnyObject {
    func configurationChosen(configuration: [DynamicSegments.Configuration.Item])
}

public class DynamicSegments: UIView {
    typealias DataSourceCollection = UICollectionViewDiffableDataSource<AnyHashable,Configuration.Item>
    typealias collectionSnapshot = NSDiffableDataSourceSnapshot<AnyHashable, Configuration.Item>
    
    private var delegate: DynamicSegmentsDelegate?
    private var configuration: Configuration
    
    private lazy var firstCollectionView: UICollectionView = generateCollectionView()
    private lazy var secondCollectionView: UICollectionView = generateCollectionView()
    
    private let mainView = UIView()
    private let slidingView = UIView()
    private var slideViewIsVisible: Bool = false
    private var animationCompleted: Bool = true
    private var currentlySelectedItemInFirstView = IndexPath(item: 0, section: 0)
    private lazy var firstDataSource: DataSourceCollection = generateDataSource(collectionView: firstCollectionView)
    private lazy var secondDataSource: DataSourceCollection = generateDataSource(collectionView: secondCollectionView)
    
    public var closedHeight: Double = 60.0
    public var heightConstraintReference: NSLayoutConstraint?
    public override var backgroundColor: UIColor? {
        didSet {
            firstCollectionView.backgroundColor = backgroundColor
            secondCollectionView.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Init
    public init(options: Node<Configuration.Item>) {
        self.configuration = Configuration(options)
        super.init(frame: .zero)
        
        firstCollectionView.delegate = self
        firstCollectionView.accessibilityIdentifier = "first"
        secondCollectionView.delegate = self
        secondCollectionView.accessibilityIdentifier = "second"
        setupView()
        updateDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func setupView() {
        addSubview(slidingView)
        addSubview(mainView)
        
        slidingView.frame = CGRect(x: 0, y: 0, width: ScreenSize.Width, height: 60)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leftAnchor.constraint(equalTo: leftAnchor),
            mainView.rightAnchor.constraint(equalTo: rightAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        mainView.addSubview(firstCollectionView)
        firstCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            firstCollectionView.rightAnchor.constraint(equalTo: mainView.rightAnchor),
            firstCollectionView.leftAnchor.constraint(equalTo: mainView.leftAnchor),
            firstCollectionView.topAnchor.constraint(equalTo: mainView.topAnchor),
            firstCollectionView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        slidingView.addSubview(secondCollectionView)
        secondCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            secondCollectionView.rightAnchor.constraint(equalTo: slidingView.rightAnchor),
            secondCollectionView.leftAnchor.constraint(equalTo: slidingView.leftAnchor),
            secondCollectionView.topAnchor.constraint(equalTo: slidingView.topAnchor),
            secondCollectionView.bottomAnchor.constraint(equalTo: slidingView.bottomAnchor)
        ])
        
    }
    
    //MARK: - Diffable DataSource
    private func generateDataSource(collectionView: UICollectionView) -> DataSourceCollection {
        let dataSource: DataSourceCollection = .init(collectionView: collectionView) {
            collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DynamicSegmentCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? DynamicSegmentCollectionViewCell
            cell?.configure(item: item)
            
            return cell
        }
         
        return dataSource
    }
    
    // MARK: - Update DataSource
    private func updateDataSource() {
        var snapshotFirst = collectionSnapshot()
        var snapshotSecond = collectionSnapshot()
        
        snapshotFirst.appendSections(["Section1"])
        snapshotFirst.appendItems(configuration.viewModelForTopPart, toSection: "Section1")
        snapshotSecond.appendSections(["SecondSection"])
        snapshotSecond.appendItems(configuration.availableOptionsAtCurrentState, toSection: "SecondSection")
        
        firstDataSource.apply(snapshotFirst)
        secondDataSource.apply(snapshotSecond)
    }
    
    // MARK: - Interactions
    public func slideOut() {
        guard animationCompleted else { return }
        
        if(!slideViewIsVisible) {
            animationCompleted = false
            UIView.animate(withDuration: 0.3, animations: {
                self.slidingView.frame.origin.y = self.mainView.frame.height
            }) { _ in
                self.slideViewIsVisible = true
                self.heightConstraintReference?.constant = self.mainView.frame.height + self.slidingView.frame.height
                self.animationCompleted = true
            }
        }
    }
    
    public func slideIn() {
        guard animationCompleted else { return }
        
        if(slideViewIsVisible) {
            animationCompleted = false
            hideAnimation {
                self.slideViewIsVisible = false
                self.animationCompleted = true
            }
        }
    }
    
    private func hideAnimation(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3, animations: {
            self.slidingView.frame.origin.y = 0
            self.heightConstraintReference?.constant = self.closedHeight
        }) { _ in
            completion()
        }
    }
}

// MARK: - CollectionView Generator
extension DynamicSegments {
    func generateCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 5, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 12
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
        collectionView.register(DynamicSegmentCollectionViewCell.self, forCellWithReuseIdentifier: DynamicSegmentCollectionViewCell.reuseIdentifier)
    
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }
}

// MARK: - Delegate
extension DynamicSegments: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.accessibilityIdentifier == "first" {
            if(configuration.currentItemIndex >= indexPath.row) {
                currentlySelectedItemInFirstView = indexPath
                configuration.seeOptionsForPrevSections(indexPath.row)
                self.slideOut()
                self.updateDataSource()
            } else {
                collectionView.deselectItem(at: indexPath, animated: false)
                collectionView.selectItem(at: currentlySelectedItemInFirstView, animated: false, scrollPosition: .top)
                self.slideOut()
            }
        } else {
            if let item = secondDataSource.itemIdentifier(for: indexPath),
               let _ = self.configuration.chooseOption(item: item)
            {
                self.updateDataSource()
                var reloadPaths = [IndexPath]()
                (0..<firstCollectionView.numberOfItems(inSection: 0)).indices.forEach { rowIndex in
                    let indexPath = IndexPath(row: rowIndex, section: 0)
                    reloadPaths.append(indexPath)
                }
                let nextIndex = IndexPath(item: currentlySelectedItemInFirstView.item + 1, section: 0)
                if(nextIndex <= reloadPaths[reloadPaths.count - 1]) {
                    firstCollectionView.selectItem(at: nextIndex, animated: true, scrollPosition: .top)
                    currentlySelectedItemInFirstView = nextIndex
                } else {
                    slideIn()
                }
            }
        }
    }
}
