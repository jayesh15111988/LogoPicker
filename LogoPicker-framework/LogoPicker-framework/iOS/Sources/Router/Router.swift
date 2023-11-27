//
//  SettingsRouter.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit

struct Router {

    /// A router function to route to specific path on OS
    /// - Parameter url: An URL representing location to which routing must happen
    static func route(to url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
