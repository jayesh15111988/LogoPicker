//
//  SettingsRouter.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit

struct Router {
    static func route(to url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
