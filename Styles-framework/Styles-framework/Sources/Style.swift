//
//  Style.swift
//  Styles-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit

/// A style framework to encode all the app styles. Includes color, images etc.
public final class Style {
    
    public static let shared = Style()

    private let bundle: Bundle

    private init() {
        self.bundle = Bundle(for: type(of: self))
    }

    public lazy var defaultTextColor: UIColor = {
        UIColor(named: "defaultTextColor", in: self.bundle, compatibleWith: nil)!
    }()

    public lazy var subtleTextColor: UIColor = {
        UIColor(named: "subtleTextColor", in: self.bundle, compatibleWith: nil)!
    }()

    public lazy var backgroundColor: UIColor = {
        UIColor(named: "backgroundColor", in: self.bundle, compatibleWith: nil)!
    }()

    public lazy var logoBackgroundColor: UIColor = {
        UIColor(named: "logoBackgroundColor", in: self.bundle, compatibleWith: nil)!
    }()

    public lazy var logoForegroundColor: UIColor = {
        UIColor(named: "logoForegroundColor", in: self.bundle, compatibleWith: nil)!
    }()

    public lazy var sectionHeaderBackgroundColor: UIColor = {
        UIColor(named: "sectionHeaderBackground", in: self.bundle, compatibleWith: nil)!
    }()
}
