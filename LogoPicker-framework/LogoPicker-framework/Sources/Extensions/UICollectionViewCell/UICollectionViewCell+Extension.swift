//
//  UICollectionViewCell+Extension.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit

//An extension to automatically provide reuse identifier for any UICollectionViewCell subclass
extension UICollectionViewCell: ReusableView {

    /// Returns the string representation of UICollectionViewCell subclass
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
