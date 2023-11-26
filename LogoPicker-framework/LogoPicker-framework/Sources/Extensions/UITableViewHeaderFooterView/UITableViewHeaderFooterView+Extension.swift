//
//  UITableViewHeaderFooterView+Extension.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension UITableViewHeaderFooterView: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
