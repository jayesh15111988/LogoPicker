//
//  LogoView.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit
import OSLog

public protocol TapEventHandalable: AnyObject {
    func logoViewTapped()
}

public class LogoView: UIView {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LogoView.self)
    )

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

    private var viewModel: ViewModel?
    public weak var delegate: TapEventHandalable?

    public struct ViewModel {

        let logoState: LogoState
        let backgroundColor: UIColor
        let foregroundColor: UIColor
        let logoContentMode: ContentMode
        let tappable: Bool

        public init(logoState: LogoState, backgroundColor: UIColor, foregroundColor: UIColor, logoContentMode: ContentMode = .scaleAspectFill, tappable: Bool = false) {

            self.logoState = logoState
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.logoContentMode = logoContentMode
            self.tappable = tappable
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addTapGestureRecognizer()
    }

    private func setupViews() {
        //To support rounded corners
        self.clipsToBounds = true

        self.addSubview(backgroundView)
        self.addSubview(logoImageView)
        self.addSubview(initialsLabel)
    }

    private func addTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(LogoView.handleTapGesture(_:)))
        self.addGestureRecognizer(recognizer)
        self.isUserInteractionEnabled = true
    }

    @objc private func handleTapGesture(_ recognizer: UITapGestureRecognizer) {

        guard viewModel?.tappable == true else {
            return
        }

        guard let delegate else {
            Self.logger.warning("Delegate must be set up on \(String(describing: LogoView.self)) class in order to receive touch events")
            return
        }
        delegate.logoViewTapped()
    }

    public func configure(with viewModel:ViewModel) {
        
        self.viewModel = viewModel

        self.backgroundView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.width, height: self.frame.height))
        self.logoImageView.frame = self.backgroundView.frame

        self.initialsLabel.frame.size = CGSize(width: self.frame.width - 2 * Constants.horizontalSpacing, height: self.frame.height / 3.0)
        self.initialsLabel.center = CGPointMake(bounds.midX, bounds.midY)

        self.backgroundView.backgroundColor = viewModel.backgroundColor
        self.initialsLabel.textColor = viewModel.foregroundColor
        self.logoImageView.contentMode = viewModel.logoContentMode

        updateLogoState(with: viewModel.logoState)
    }

    public func updateLogoState(with newState: LogoState) {

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
