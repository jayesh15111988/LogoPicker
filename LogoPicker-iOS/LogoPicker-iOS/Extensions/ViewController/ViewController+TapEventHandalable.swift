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
        let logoPickerViewModel = LogoPickerViewController.ViewModel(
            logoViewModel: LogoViewModel(logoState: logoState),
            logoFrameSize: .square(dimension: 150)
        )

        let logoPickerViewController = LogoPickerViewController(viewModel: logoPickerViewModel)

        //A delegate that will be called after user successfully picks the new logo image. User needs to dismiss the view by themselves to proceed.
        logoPickerViewController.delegate = self
        self.present(logoPickerViewController, animated: true)
    }
}
