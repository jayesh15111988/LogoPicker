//
//  ViewController+LogoPickerViewControllerDelegate.swift
//  LogoPicker-iOS
//
//  Created by Jayesh Kawli on 11/26/23.
//

import Foundation

import LogoPicker_framework

extension ViewController: LogoPickerViewControllerDelegate {
    
    //A method that will be called when the user cancelled logo picker operation without choosing a new image
    func selectionCancelled() {
        self.presentedViewController?.dismiss(animated: true)
    }

    //A method that will be called with LogoState enum indicating the user selection
    func selectionCompleted(logoState: LogoState) {
        self.logoView.updateLogoState(with: logoState)
        self.logoState = logoState
        self.presentedViewController?.dismiss(animated: true)
    }
}
