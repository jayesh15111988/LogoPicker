//
//  LogoMediaTableViewCell+UICollectionViewDelegateFlowLayout.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit

extension LogoMediaTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //Passed frame size by caller
        if let frameSize {
            return CGSize(width: frameSize.width, height: frameSize.height)
        }
        return CGSize(width: 64.0, height: 64.0)
    }
}
