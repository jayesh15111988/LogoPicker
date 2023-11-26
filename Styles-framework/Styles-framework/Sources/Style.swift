//
//  Style.swift
//  Styles-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

/// A style framework to encode all the app styles. Includes color, images etc.
public final class Style {
    
    public static let shared = Style()

    private let bundle: Bundle

    private init() {
        self.bundle = Bundle(for: type(of: self))
    }

#if os(iOS)
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
#elseif os(OSX)
    public lazy var defaultTextColor: NSColor = {
        NSColor(named: "defaultTextColor", bundle: self.bundle)!
    }()

    public lazy var subtleTextColor: NSColor = {
        NSColor(named: "subtleTextColor", bundle: self.bundle)!
    }()

    public lazy var backgroundColor: NSColor = {
        NSColor(named: "backgroundColor", bundle: self.bundle)!
    }()

    public lazy var logoBackgroundColor: NSColor = {
        NSColor(named: "logoBackgroundColor", bundle: self.bundle)!
    }()

    public lazy var logoForegroundColor: NSColor = {
        NSColor(named: "logoForegroundColor", bundle: self.bundle)!
    }()

    public lazy var sectionHeaderBackgroundColor: NSColor = {
        NSColor(named: "sectionHeaderBackground", bundle: self.bundle)!
    }()
#endif
}
