//
//  LogoPickerViewController+ImageSelectionCompletionDelegate.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/27/23.
//

import Foundation

//MARK: ImageSelectionCompletionDelegate delegate
extension LogoPickerViewController: ImageSelectionCompletionDelegate {

    /// A delegate method to call after image is selected. We will update the preview right after it.
    /// - Parameter state: A new logo state
    func imageSelected(state: LogoState) {
        updatePreview(with: state)
    }
}
