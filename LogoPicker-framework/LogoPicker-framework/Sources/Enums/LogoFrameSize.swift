//
//  LogoFrameSize.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import Foundation

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
