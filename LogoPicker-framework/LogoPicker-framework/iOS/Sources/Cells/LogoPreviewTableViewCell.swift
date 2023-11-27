//
//  LogoPreviewTableViewCell.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit

/// A table view cell to show the preview of currently selected logo image
/// It could either be an image or stylized initials
final class LogoPreviewTableViewCell: UITableViewCell {

    private let logoView: LogoView = {
        let logoView = LogoView(frame: .zero)
        return logoView
    }()

    //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    //MARK: Setup views
    private func setupViews() {
        self.contentView.addSubview(logoView)
    }

    /// A method to configure cell with provided parameters
    /// - Parameters:
    ///   - viewModel: A view model to decorate logoView
    ///   - logoFrameSize: A desired frame size for logo view
    func configure(with viewModel: LogoView.ViewModel, logoFrameSize: LogoFrameSize) {

        logoView.frame.size = CGSize(width: logoFrameSize.width, height: logoFrameSize.height)
        logoView.center = self.contentView.center
        logoView.configure(with: viewModel)
    }

    /// A method to update logo view with new logo state
    /// - Parameter newLogoState: Selected logo image in the form of LogoState enum
    func update(with newLogoState: LogoState) {
        logoView.updateLogoState(with: newLogoState)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        logoView.resetState()
    }
}
