//
//  UITableViewHeaderFooterView+Extension.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit

extension UITableViewHeaderFooterView: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
