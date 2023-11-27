//
//  LogoMediaCollectionViewCell.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit

/// A collection view cell subclass to show individual logo media in horizontal scrollable format
final class LogoMediaCollectionViewCell: UICollectionViewCell {

    // A view model to encode parameters needed to design logo media cell
    struct ViewModel {
        let image: UIImage
    }

    private enum Constants {
        static let horizontalPadding: CGFloat = 0.0
        static let verticalPadding: CGFloat = 0.0
    }

    let logoView = LogoView(frame: .zero)

    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.clipsToBounds = true
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: setup views
    private func setupViews() {
        self.contentView.addSubview(logoView)
    }

    //MARK: layout views
    private func layoutViews() {
        logoView.frame = CGRect(origin: CGPoint(x: Constants.horizontalPadding, y: Constants.verticalPadding), size: CGSize(width: self.contentView.bounds.width - (2 * Constants.horizontalPadding), height: self.contentView.bounds.height - (2 * Constants.verticalPadding)))

        logoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    /// A method to configure cell with provided view model
    /// - Parameter viewModel: An instance of LogoView.ViewModel to be applied to LogoView instance
    func configure(with viewModel: LogoView.ViewModel) {
        logoView.configure(with: viewModel)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        logoView.resetState()
    }
}
