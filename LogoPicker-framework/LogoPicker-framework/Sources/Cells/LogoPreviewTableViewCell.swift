//
//  LogoPreviewTableViewCell.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit

class LogoPreviewTableViewCell: UITableViewCell {

    private let logoView: LogoView = {
        let logoView = LogoView(frame: .zero)
        return logoView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    private func setupViews() {
        self.contentView.addSubview(logoView)
    }

    func configure(with viewModel: LogoView.ViewModel, logoFrameSize: CGSize) {
        logoView.frame.size = logoFrameSize
        logoView.center = self.contentView.center
        logoView.configure(with: viewModel)
        logoView.backgroundColor = .red
    }

    func update(with newLogoState: LogoState) {
        logoView.updateLogoState(with: newLogoState)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
