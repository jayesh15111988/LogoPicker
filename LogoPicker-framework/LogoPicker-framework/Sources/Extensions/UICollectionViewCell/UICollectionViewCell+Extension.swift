//
//  UICollectionViewCell+Extension.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

//An extension to automatically provide reuse identifier for any UICollectionViewCell subclass
extension UICollectionViewCell: ReusableView {

    /// Returns the string representation of UICollectionViewCell subclass
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
