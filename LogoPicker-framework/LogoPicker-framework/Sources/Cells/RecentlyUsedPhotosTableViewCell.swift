//
//  RecentlyUsedPhotosTableViewCell.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit
import OSLog

protocol ImageSelectionCompletionDelegate: AnyObject {
    func imageSelected(state: LogoState)
}

final class RecentlyUsedPhotosTableViewCell: UITableViewCell {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: RecentlyUsedPhotosTableViewCell.self)
    )

    var recentImagesLogoViewModelCollection: [LogoView.ViewModel] = []

    weak var imageSelectionCompletionDelegate: ImageSelectionCompletionDelegate?

    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutViews()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func registerCells() {
        collectionView.register(RecentImageCollectionViewCell.self, forCellWithReuseIdentifier: RecentImageCollectionViewCell.reuseIdentifier)
    }

    private func setupViews() {
        self.contentView.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func layoutViews() {
        collectionView.frame = CGRect(origin: .zero, size: self.contentView.bounds.size)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func configure(with logoViewModels: [LogoView.ViewModel]) {
        recentImagesLogoViewModelCollection = logoViewModels
        self.collectionView.reloadData()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        recentImagesLogoViewModelCollection = []
    }
}

extension RecentlyUsedPhotosTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentImagesLogoViewModelCollection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentImageCollectionViewCell.reuseIdentifier, for: indexPath) as? RecentImageCollectionViewCell else {
            fatalError("Failed to get expected kind of reusable cell from the collectionView. Expected RecentImageCollectionViewCell")
        }
        cell.configure(with: recentImagesLogoViewModelCollection[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let imageSelectionCompletionDelegate else {
            Self.logger.warning("Delegate must be set up on \(String(describing: RecentlyUsedPhotosTableViewCell.self)) class in order to receive recent images selection events")
            return
        }

        let selectedRecentImagesLogoViewModel = recentImagesLogoViewModelCollection[indexPath.row]
        imageSelectionCompletionDelegate.imageSelected(state: selectedRecentImagesLogoViewModel.logoState)
    }
}

extension RecentlyUsedPhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64, height: 64)
    }
}
