//
//  UITableViewCell+Extension.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

//An extension to automatically provide reuse identifier for any UITableViewCell subclass
extension UITableViewCell: ReusableView {

    /// Returns the string representation of UITableViewCell subclass
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
