//
//  LogoPickerViewController+UIImagePickerControllerDelegate.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit

extension LogoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// A method that gets called once the user has finalized the captured image
    /// - Parameters:
    ///   - picker: An instance of UIImagePickerController from which image is clicked
    ///   - info: Info dictionary with image metadata
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            alertDisplayUtility.showAlert(with: AlertInfo(title: "Unable to get image", message: "App is unable to get the clicked image. Please try again."), parentViewController: self)
            return
        }

        updatePreview(with: .image(viewModel: LogoState.ImageViewModel(image: image)))
    }
}
