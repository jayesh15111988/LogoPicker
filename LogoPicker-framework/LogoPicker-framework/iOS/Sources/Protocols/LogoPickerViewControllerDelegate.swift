//
//  LogoPickerViewControllerDelegate.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import Foundation

// A protocol to inform client of logo media selection completion
public protocol LogoPickerViewControllerDelegate: AnyObject {
    func selectionCancelled()
    func selectionCompleted(logoState: LogoState)
}
