//
//  LogoFrameSize.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import Foundation

/// An enum to encode logo frame size. Currently only support square layout. Can be extended to support further custom formats 
public enum LogoFrameSize {
    case square(dimension: CGFloat)

    var width: CGFloat {
        switch self {
        case .square(let dimension):
            return dimension
        }
    }

    var height: CGFloat {
        switch self {
        case .square(let dimension):
            return dimension
        }
    }
}
