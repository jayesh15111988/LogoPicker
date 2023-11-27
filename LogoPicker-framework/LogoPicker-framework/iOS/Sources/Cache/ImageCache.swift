//
//  ImageCache.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit

import Styles_framework

/// Dummy class to store recently used images in the cache
final public class ImageCache {

    static let shared = ImageCache()

    private let recentImageCollection: [UIImage]

    private init() {
        //Mocking recent images for testing. In production, LogoPicker framework will store recently used images in the cache and present them when the picker is shown to the user

        //A dummy set of recently selected image. This will probably be provided by the server during app startup or the instance user lands on the profile page

        let bundle = Bundle(for: type(of: self))

        let genericPlaceholderImage = Style.shared.profilePlaceholder

        recentImageCollection = [
            UIImage(named: "placeholder_1", in: bundle, with: nil),
            genericPlaceholderImage,
            UIImage(named: "placeholder_2", in: bundle, with: nil),
            genericPlaceholderImage,
            UIImage(named: "placeholder", in: bundle, with: nil),
            genericPlaceholderImage,
            UIImage(named: "placeholder", in: bundle, with: nil),
            genericPlaceholderImage,
            UIImage(named: "placeholder_1", in: bundle, with: nil)
        ]
            .compactMap { $0 }
    }

    func recentImages() -> [UIImage] {
        return recentImageCollection
    }
}
