//
//  ViewController.swift
//  LogoPicker-iOS
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit
import LogoPicker_framework

typealias ViewModel = LogoView.ViewModel

class ViewController: UIViewController {

    var logoState: LogoState = .title(initials: "JK")

    private enum Constants {
        static let horizontalSpacing: CGFloat = 10.0
    }

    private let logoView: LogoView = {
        let logoView = LogoView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 75, height: 75)))
        return logoView
    }()

    private let logoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()

    private let logoSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
    }

    private func setupViews() {

        logoView.delegate = self
        logoTitleLabel.text = "Icon"
        logoSubtitleLabel.text = "Tap to Change Icon"

        self.view.addSubview(logoTitleLabel)
        self.view.addSubview(logoSubtitleLabel)
        self.view.addSubview(logoView)
    }

    private func layoutViews() {
        logoView.frame.origin = CGPoint(x: Constants.horizontalSpacing, y: self.view.bounds.midY - logoView.frame.height / 2.0)
        logoView.configure(with: ViewModel(logoState: logoState, backgroundColor: .blue, foregroundColor: .white, logoContentMode: .scaleAspectFill, tappable: true))

        let titlesHorizontalSpacing = Constants.horizontalSpacing * 2 + logoView.frame.width
        let titlesWidth = self.view.frame.width - 2 * Constants.horizontalSpacing - Constants.horizontalSpacing - logoView.frame.width
        let titlesHeight = logoView.frame.height / 3.0
        let yOffsetFromCenter = logoView.frame.height / 4.0

        logoTitleLabel.frame = CGRect(origin: CGPoint(x: titlesHorizontalSpacing, y: self.logoView.center.y - yOffsetFromCenter), size: CGSize(width: titlesWidth, height: titlesHeight))

        logoSubtitleLabel.frame = CGRect(origin: CGPoint(x: titlesHorizontalSpacing, y: self.logoView.center.y), size: CGSize(width: titlesWidth, height: titlesHeight))

        logoTitleLabel.frame.origin.y -= 5
        logoSubtitleLabel.frame.origin.y += 5
    }
}

extension ViewController: TapEventHandalable {
    func logoViewTapped() {

        let recentImages = [UIImage(named: "placeholder_1"), UIImage(named: "placeholder"), UIImage(named: "placeholder_2"), UIImage(named: "placeholder"), UIImage(named: "placeholder"), UIImage(named: "placeholder_3"), UIImage(named: "placeholder"), UIImage(named: "placeholder"), UIImage(named: "placeholder_1")].compactMap { $0 }

        let logoPickerViewController = LogoPickerViewController(viewModel: LogoPickerViewController.ViewModel(logoViewModel: ViewModel(logoState: logoState, backgroundColor: .blue, foregroundColor: .white, logoContentMode: .scaleAspectFill, tappable: false), logoFrameSize: .square(dimension: self.logoView.frame.size.width), recentImages: recentImages))
        logoPickerViewController.delegate = self
        self.present(logoPickerViewController, animated: true)
    }
}

extension ViewController: LogoPickerViewControllerDelegate {
    func selectionCancelled() {
        self.presentedViewController?.dismiss(animated: true)
    }
    
    func selectionCompleted(logoState: LogoState) {
        self.logoView.updateLogoState(with: logoState)
        self.logoState = logoState
        self.presentedViewController?.dismiss(animated: true)
    }
}
