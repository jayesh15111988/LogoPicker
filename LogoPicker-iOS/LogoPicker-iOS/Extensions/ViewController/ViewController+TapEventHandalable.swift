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
        
        //A dummy set of recently selected image. This will probably be provided by the server during app startup or the instance user lands on the profile page
        let recentImages = [
            UIImage(named: "placeholder_1"),
            UIImage(named: "placeholder"),
            UIImage(named: "placeholder_2"),
            UIImage(named: "placeholder"),
            UIImage(named: "placeholder"),
            UIImage(named: "placeholder_3"),
            UIImage(named: "placeholder"),
            UIImage(named: "placeholder"),
            UIImage(named: "placeholder_1")
        ]
            .compactMap { $0 }

        //The main logo picker view controller which will allow users to choose the logo image of their choice
        let logoPickerViewController = LogoPickerViewController(
            viewModel: LogoPickerViewController.ViewModel(
                logoViewModel: LogoViewModel(
                    logoState: logoState,
                    backgroundColor: Style.shared.logoBackgroundColor,
                    foregroundColor: Style.shared.logoForegroundColor,
                    logoContentMode: .scaleAspectFill),
                logoFrameSize: .square(dimension: self.logoView.frame.size.width),
                recentImages: recentImages)
        )

        //A delegate that will be called after user successfully picks the new logo image
        logoPickerViewController.delegate = self
        self.present(logoPickerViewController, animated: true)
    }
}
