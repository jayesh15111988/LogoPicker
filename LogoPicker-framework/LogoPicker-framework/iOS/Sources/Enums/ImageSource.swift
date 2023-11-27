//
//  ImageSource.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import Foundation

/// An enum to encode possible image sources from which user can select images
enum ImageSource {
    case gallery
    case camera
    //Add new cases and the code to handle as necessary in the future

    var title: String {
        switch self {
        case .gallery:
            return "Pick from image gallery"
        case .camera:
            return "Click with camera"
        }
    }
}
