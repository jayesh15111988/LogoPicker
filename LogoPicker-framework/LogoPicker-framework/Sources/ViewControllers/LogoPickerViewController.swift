//
//  LogoPickerViewController.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit
import OSLog

public protocol LogoPickerViewControllerDelegate: AnyObject {
    func selectionCancelled()
    func selectionCompleted(logoState: LogoState)
}

public class LogoPickerViewController: UIViewController {

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LogoPickerViewController.self)
    )

    public struct ViewModel {
        let logoViewModel: LogoView.ViewModel
        let title: String
        let logoFrameSize: CGSize
        var selectedLogoState: LogoState

        public init(logoViewModel: LogoView.ViewModel, title: String = "Change Logo", logoFrameSize: CGSize = CGSize(width: 50, height: 50)) {
            self.logoViewModel = logoViewModel
            self.title = title
            self.logoFrameSize = logoFrameSize
            self.selectedLogoState = logoViewModel.logoState
        }
    }

    private let cancelButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()

    private let doneButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private let viewModel: ViewModel
    public var delegate: LogoPickerViewControllerDelegate?

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
    }

    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(cancelButton)
        self.view.addSubview(doneButton)

        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }

    @objc private func cancelButtonPressed(_ button: UIButton) {
        guard let delegate else {
            Self.logger.warning("Delegate must be set up on \(String(describing: LogoPickerViewController.self)) class in order to receive cancel event")
            return
        }
        delegate.selectionCancelled()
    }

    @objc private func doneButtonPressed(_ button: UIButton) {
        guard let delegate else {
            Self.logger.warning("Delegate must be set up on \(String(describing: LogoPickerViewController.self)) class in order to receive selection completed event")
            return
        }

        delegate.selectionCompleted(logoState: viewModel.selectedLogoState)
    }

    private func layoutViews() {
        self.cancelButton.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        self.doneButton.frame = CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: 0), size: CGSize(width: 100, height: 44))
    }
}
