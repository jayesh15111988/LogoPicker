//
//  ViewController.swift
//  LogoPicker-iOS
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit

import LogoPicker_framework
import Styles_framework

typealias LogoViewModel = LogoView.ViewModel

// A class to demo how logo picker works
final class ViewController: UIViewController {

    // A selected logo state
    var logoState: LogoState = .title(initials: "AB")

    private enum Constants {
        static let horizontalSpacing: CGFloat = 10.0
    }

    // LogoView showing selected logo image or the initials
    let logoView: LogoView = {
        let logoView = LogoView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 75, height: 75)))
        return logoView
    }()

    // The main title next to selected logo
    private let logoTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = Style.shared.defaultTextColor
        return label
    }()

    // The subtitle next to selected logo
    private let logoSubtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = Style.shared.subtleTextColor
        return label
    }()

    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        self.view.backgroundColor = Style.shared.backgroundColor
    }

    //MARK: Private methods
    //MARK: Setting up views
    private func setupViews() {

        // A delegate which will be called after tapping on the logo view
        logoView.delegate = self

        logoTitleLabel.text = "Icon"
        logoSubtitleLabel.text = "Tap to Change Icon"

        self.view.addSubview(logoView)
        self.view.addSubview(logoTitleLabel)
        self.view.addSubview(logoSubtitleLabel)
    }

    //MARK: Laying out views
    private func layoutViews() {

        logoView.frame.origin = CGPoint(x: Constants.horizontalSpacing, y: self.view.bounds.midY - logoView.frame.height / 2.0)

        logoView.configure(with: LogoViewModel(
            logoState: logoState,
            backgroundColor: Style.shared.logoBackgroundColor,
            foregroundColor: Style.shared.logoForegroundColor,
            logoContentMode: .scaleAspectFill,
            tappable: true
        ))

        let titlesHorizontalSpacing = Constants.horizontalSpacing * 2 + logoView.frame.width
        let titlesWidth = self.view.frame.width - 2 * Constants.horizontalSpacing - Constants.horizontalSpacing - logoView.frame.width
        let titlesHeight = logoView.frame.height / 3.0
        let yOffsetFromCenter = logoView.frame.height / 4.0

        logoTitleLabel.frame = CGRect(origin: CGPoint(x: titlesHorizontalSpacing, y: self.logoView.center.y - yOffsetFromCenter), size: CGSize(width: titlesWidth, height: titlesHeight))

        logoSubtitleLabel.frame = CGRect(origin: CGPoint(x: titlesHorizontalSpacing, y: self.logoView.center.y), size: CGSize(width: titlesWidth, height: titlesHeight))
    }
}
