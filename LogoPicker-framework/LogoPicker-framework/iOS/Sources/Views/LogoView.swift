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

/// A custom view to represent the logo in the app. The screen representation depends on passed LogoState which decides the way logo is displayed to the user
final public class LogoView: UIView {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LogoView.self)
    )

    enum Constants {
        static let horizontalPadding: CGFloat = 10.0
    }

    //A background view for logo
    private let backgroundView = UIView(frame: .zero)

    //A label representing initials for current team or the user etc.
    private let initialsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    //An image view representing user selected or current image
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()

    private var viewModel: ViewModel?
    public weak var delegate: TapEventHandalable?

    public struct ViewModel {

        let logoState: LogoState
        let tappable: Bool

        /// A method to initialize view model associated with LogoView
        /// - Parameters:
        ///   - logoState: A state indicating the current logo type. Currently support either initials or the actual image
        ///   - tappable: A bool indicating whether logo view is tappable or not. Default to false
        public init(logoState: LogoState, tappable: Bool = false) {

            self.logoState = logoState
            self.tappable = tappable
        }
    }

    //MARK: init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addTapGestureRecognizer()
    }

    //MARK: set up views
    private func setupViews() {
        //To support rounded corners
        self.clipsToBounds = true

        self.addSubview(backgroundView)
        self.addSubview(logoImageView)
        self.addSubview(initialsLabel)
    }

    //MARK: Adding tap gesture recognizer
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

    /// A method to configure LogoView with provided view model
    /// - Parameter viewModel: A view model representing an instance of LogoView.ViewModel used to decorate view
    public func configure(with viewModel:ViewModel) {
        
        self.viewModel = viewModel
        self.isUserInteractionEnabled = viewModel.tappable
        self.backgroundView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.width, height: self.frame.height))
        self.logoImageView.frame = self.backgroundView.frame

        self.initialsLabel.frame.size = CGSize(width: self.frame.width - 2 * Constants.horizontalPadding, height: self.frame.height / 3.0)

        self.initialsLabel.center = CGPointMake(bounds.midX, bounds.midY)

        updateLogoState(with: viewModel.logoState)
    }
    
    /// A method to update current logo state with newly passed state
    /// - Parameter newState: A state to be applied to current logo view
    public func updateLogoState(with newState: LogoState) {

        // Customize logo view based on the updated state
        switch newState {
        case .initials(let viewModel):

            initialsLabel.text = viewModel.initials
            backgroundView.backgroundColor = viewModel.backgroundColor
            initialsLabel.textColor = viewModel.titleColor

            initialsLabel.isHidden = false
            backgroundView.isHidden = false
            logoImageView.isHidden = true

        case .image(let viewModel):

            logoImageView.image = viewModel.image
            logoImageView.contentMode = viewModel.contentMode

            backgroundView.isHidden = true
            initialsLabel.isHidden = true
            logoImageView.isHidden = false

        case .color(let viewModel):

            backgroundView.backgroundColor = viewModel.color

            backgroundView.isHidden = false
            initialsLabel.isHidden = true
            logoImageView.isHidden = true
        }

        self.layer.cornerRadius = newState.cornerRadius(for: self.frame.width)
    }
    
    /// A method to reset view state when it is used with reusable table view cells
    func resetState() {
        viewModel = nil
        initialsLabel.text = nil
        logoImageView.image = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
