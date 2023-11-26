//
//  SettingsRouter.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

struct Router {
    static func route(to url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
