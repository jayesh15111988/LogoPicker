//
//  LogoView.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit

public class LogoView: UIView {

    enum Constants {
        static let horizontalSpacing: CGFloat = 10.0
    }

    private let backgroundView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()

    private let initialsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()

    public enum LogoState {
        case title(initials: String)
        case image(logoImage: UIImage)
    }

    private var viewModel: ViewModel?

    public struct ViewModel {

        let logoState: LogoState
        let backgroundColor: UIColor
        let foregroundColor: UIColor
        let logoContentMode: ContentMode

        public init(logoState: LogoState, backgroundColor: UIColor, foregroundColor: UIColor, logoContentMode: ContentMode = .scaleAspectFit) {

            self.logoState = logoState
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.logoContentMode = logoContentMode
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    private func setupViews() {
        //To support rounded corners
        self.clipsToBounds = true

        self.addSubview(backgroundView)
        self.addSubview(logoImageView)
        self.addSubview(initialsLabel)

        self.backgroundView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.width, height: self.frame.height))
        self.logoImageView.frame = self.backgroundView.frame

        self.initialsLabel.frame.size = CGSize(width: self.frame.width - 2 * Constants.horizontalSpacing, height: self.frame.height / 3.0)
        self.initialsLabel.center = CGPointMake(bounds.midX, bounds.midY)
    }

    public func configure(with viewModel:ViewModel) {
        
        self.viewModel = viewModel

        self.backgroundView.backgroundColor = viewModel.backgroundColor
        self.initialsLabel.textColor = viewModel.foregroundColor
        self.logoImageView.contentMode = viewModel.logoContentMode

        updateLogoState(with: viewModel.logoState)
    }

    public func updateLogoState(with newState: LogoState) {

        guard let viewModel else {
            return
        }

        switch newState {
        case .title(let initials):
            initialsLabel.text = initials
            initialsLabel.isHidden = false
            backgroundView.isHidden = false
            logoImageView.isHidden = true
            self.layer.cornerRadius = self.frame.width / 4.0
        case .image(let logoImage):
            logoImageView.image = logoImage
            backgroundView.isHidden = true
            initialsLabel.isHidden = true
            logoImageView.isHidden = false
            self.layer.cornerRadius = self.frame.width / 2.0
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
