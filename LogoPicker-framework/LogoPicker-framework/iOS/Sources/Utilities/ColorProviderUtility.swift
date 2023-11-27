//
//  ColorProviderUtility.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/27/23.
//

import UIKit

/// A dummy utility to provide random colors to be used in other parts of the framework. Allows user choosing between colors and customize the appearance of UI
final class ColorProviderUtility {

    private static func randomColors() -> [UIColor] {
        return [
            UIColor.black,
            UIColor.purple,
            UIColor.green,
            UIColor.yellow,
            UIColor.brown,
            UIColor.darkGray,
            UIColor.cyan,
            UIColor.lightGray,
            UIColor.magenta,
            UIColor.orange
        ]
    }

    static func foregroundColors() -> [UIColor] {
        return randomColors()
    }

    static func backgroundColors() -> [UIColor] {
        return randomColors()
    }

}
