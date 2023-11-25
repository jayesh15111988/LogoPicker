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

    private enum Constants {
        static let horizontalSpacing: CGFloat = 10.0
    }

    private let logoView: LogoView = {
        let logoView = LogoView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50, height: 50)))
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
    }

    private func setupViews() {

        logoView.delegate = self
        logoTitleLabel.text = "Icon"
        logoSubtitleLabel.text = "Tap to Change Icon"

        self.view.addSubview(logoTitleLabel)
        self.view.addSubview(logoSubtitleLabel)
        self.view.addSubview(logoView)

        logoView.frame.origin = CGPoint(x: Constants.horizontalSpacing, y: self.view.bounds.midY - logoView.frame.height / 2.0)
        logoView.configure(with: ViewModel(logoState: .title(initials: "JK"), backgroundColor: .blue, foregroundColor: .white, logoContentMode: .scaleAspectFit))

        let titlesHorizontalSpacing = Constants.horizontalSpacing * 2 + logoView.frame.width
        let titlesWidth = self.view.frame.width - 2 * Constants.horizontalSpacing - Constants.horizontalSpacing - logoView.frame.width
        let titlesHeight = logoView.frame.height / 4.0
        let yOffsetFromCenter = logoView.frame.height / 4.0

        logoTitleLabel.frame = CGRect(origin: CGPoint(x: titlesHorizontalSpacing, y: self.logoView.center.y - yOffsetFromCenter), size: CGSize(width: titlesWidth, height: titlesHeight))

        logoSubtitleLabel.frame = CGRect(origin: CGPoint(x: titlesHorizontalSpacing, y: self.logoView.center.y), size: CGSize(width: titlesWidth, height: titlesHeight))

        logoTitleLabel.frame.origin.y -= 5
        logoSubtitleLabel.frame.origin.y += 5
    }
}

extension ViewController: TapEventHandalable {
    func logoViewTapped() {

    }
}

