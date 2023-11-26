//
//  RecentlyUsedPhotosTableViewCell+UICollectionViewDelegateDataSource.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit

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
            Self.logger.warning("Delegate must be set up on \(String(describing: RecentlyUsedPhotosTableViewCell.self)) class in order to receive images selection events")
            return
        }

        let selectedRecentImagesLogoViewModel = recentImagesLogoViewModelCollection[indexPath.row]
        imageSelectionCompletionDelegate.imageSelected(state: selectedRecentImagesLogoViewModel.logoState)
    }
}
