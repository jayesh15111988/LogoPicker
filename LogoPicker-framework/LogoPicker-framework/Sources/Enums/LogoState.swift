//
//  LogoState.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

/// An enum to encode the logo state. It currently has two forms. First, showing initials and second, an actual image
public enum LogoState {
    case title(initials: String)
    case image(logoImage: UIImage)

    func cornerRadius(for width: CGFloat) -> CGFloat {
        switch self {
        case .title:
            return width / 4.0
        case .image:
            return width / 2.0
        }
    }
}
