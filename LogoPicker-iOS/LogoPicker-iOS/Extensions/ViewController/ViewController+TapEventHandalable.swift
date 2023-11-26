//
//  ViewController+TapEventHandalable.swift
//  LogoPicker-iOS
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit

import LogoPicker_framework
import Styles_framework

extension ViewController: TapEventHandalable {

    func logoViewTapped() {

        //The main logo picker view controller which will allow users to choose the logo image of their choice
        let logoPickerViewController = LogoPickerViewController(
            viewModel: LogoPickerViewController.ViewModel(
                logoViewModel: LogoViewModel(
                    logoState: logoState,
                    backgroundColor: Style.shared.logoBackgroundColor,
                    foregroundColor: Style.shared.logoForegroundColor,
                    logoContentMode: .scaleAspectFill),
                logoFrameSize: .square(dimension: 200)
            )
        )

        //A delegate that will be called after user successfully picks the new logo image
        logoPickerViewController.delegate = self
        self.present(logoPickerViewController, animated: true)
    }
}
