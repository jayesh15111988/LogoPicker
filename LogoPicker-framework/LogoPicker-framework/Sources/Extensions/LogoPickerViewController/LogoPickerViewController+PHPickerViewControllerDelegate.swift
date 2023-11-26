//
//  LogoPickerViewController+PHPickerViewControllerDelegate.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
import PhotosUI

extension LogoPickerViewController: PHPickerViewControllerDelegate {

    /// A delegate method that gets called after user has picked up image from gallery
    /// - Parameters:
    ///   - picker: An instance of PHPickerViewController from which image is picked
    ///   - results: Collection of object representing image
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true)

        if let itemProvider = results.first?.itemProvider {
            if itemProvider.canLoadObject(ofClass: UIImage.self){
                itemProvider.loadObject(ofClass: UIImage.self) { image , error  in
                    if let error {
                        self.alertDisplayUtility.showAlert(with: AlertInfo(title: "Unable to load selected image", message: "App is unable to load selected image due to an error \(error.localizedDescription)"), parentViewController: self)
                        return
                    }
                    if let selectedImage = image as? UIImage{
                        self.updatePreview(with: .image(logoImage: selectedImage))
                    } else {
                        Self.logger.warning("Unable to convert selected object from item provider to UIImage")

                        self.alertDisplayUtility.showAlert(with: AlertInfo(title: "Invalid object", message: "Unable to convert current object to image. Please try again"), parentViewController: self)
                    }
                }
            }
        }
    }
}
