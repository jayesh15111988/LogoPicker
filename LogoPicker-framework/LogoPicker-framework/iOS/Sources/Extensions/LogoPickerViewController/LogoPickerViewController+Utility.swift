//
//  LogoPickerViewController+Utility.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/27/23.
//

import UIKit

//Utility extension
extension LogoPickerViewController {

    /// A method to update preview with selected logo state
    /// - Parameter logoState: A new logo state to update preview with
    func updatePreview(with logoState: LogoState) {

        let newLogoState: LogoState

        // We need to perform update on the existing logo view model and refresh the view
        let oldViewModel = self.updatedLogoViewModel

        switch logoState {
            //User is never expected to reach this state
        case .initials:
            fatalError("Unexpected program flow. The control should never reach here once the media is updated")
            break
        case .image:
            guard let previousContentMode = logoState.contentMode, let selectedImage = logoState.selectedImage else {
                Self.logger.error("Application must have initial selected image and content mode if the user has selected image. The app has entered an invalid state. Unable to proceed")
                return
            }
            newLogoState = LogoState.image(viewModel: .init(image: selectedImage, contentMode: previousContentMode))
            self.selectedImageLogoState = newLogoState
        case .color(let viewModel):

            // We need to extract these parameters from previous state
            guard
                let previousForegroundColor = selectedInitialsLogoState.foregroundColor,
                let previousBackgroundColor = selectedInitialsLogoState.backgroundColor, let name = selectedInitialsLogoState.name else {

                return
            }

            let newForegroundColor = viewModel.type == .foreground ? viewModel.color : previousForegroundColor

            let newBackgroundColor = viewModel.type == .background ? viewModel.color : previousBackgroundColor

            newLogoState = LogoState.initials(viewModel: LogoState.InitialsViewModel(name: name, titleColor: newForegroundColor, backgroundColor: newBackgroundColor))

            self.selectedInitialsLogoState = newLogoState
        }

        self.updatedLogoViewModel = LogoView.ViewModel(logoState: newLogoState, tappable: oldViewModel.tappable)

        // We cannot guarantee position of preview section in our table view so need to manually extract it
        if let previewSectionIndex = self.sections.firstIndex(where: {
            if case .preview = $0 {
                return true
            }
            return false
        }) {
            DispatchQueue.main.async {
                self.tableView.reloadSections([previewSectionIndex], with: .none)
            }
        } else {
            Self.logger.error("App cannot find preview section in the app. Please make sure preview section is added and is visible to the user")
        }
    }
}
