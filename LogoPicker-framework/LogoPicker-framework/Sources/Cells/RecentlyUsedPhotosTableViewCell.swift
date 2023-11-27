//
//  RecentlyUsedPhotosTableViewCell.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit
import OSLog

/// A cell to show the collection of recently used logo images

protocol ImageSelectionCompletionDelegate: AnyObject {

    /// A method to be called when the user has selected new logo image
    /// - Parameter state: A state representing selected image
    func imageSelected(state: LogoState)
}

final class RecentlyUsedPhotosTableViewCell: UITableViewCell {

    static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: RecentlyUsedPhotosTableViewCell.self)
    )

    var frameSize: LogoFrameSize?

    /// A view models collection for recently used images
    var recentImagesLogoViewModelCollection: [LogoView.ViewModel] = []

    // A delegate to be notified when the image is selected
    weak var imageSelectionCompletionDelegate: ImageSelectionCompletionDelegate?

    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutViews()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: register cells
    private func registerCells() {
        collectionView.register(RecentImageCollectionViewCell.self, forCellWithReuseIdentifier: RecentImageCollectionViewCell.reuseIdentifier)
    }

    //MARK: setup views
    private func setupViews() {
        self.contentView.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    //MARK: layout views
    private func layoutViews() {
        collectionView.frame = CGRect(origin: .zero, size: self.contentView.bounds.size)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    /// A method to configure cell with provided view models
    /// - Parameter logoViewModels: An array of LogoView.ViewModel instances representing view models for LogoView instances
    /// - Parameter frameSize: Frame size for recently used logo images
    func configure(with logoViewModels: [LogoView.ViewModel], frameSize: LogoFrameSize) {
        recentImagesLogoViewModelCollection = logoViewModels
        self.frameSize = frameSize
        self.collectionView.reloadData()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        recentImagesLogoViewModelCollection = []
    }
}
