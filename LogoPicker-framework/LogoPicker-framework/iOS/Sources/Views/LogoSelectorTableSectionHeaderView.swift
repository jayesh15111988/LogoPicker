//
//  LogoSelectorTableSectionHeaderView.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit
import Styles_framework

/// A custom header view to show different sections on image picker controller
final public class LogoSelectorTableSectionHeaderView: UITableViewHeaderFooterView {
    
    /// A view model to encode parameters needed to decorate header
    public struct ViewModel {
        let title: String
    }

    private enum Constants {
        enum Padding {
            static let horizontal: CGFloat = 10.0
            static let vertical: CGFloat = 5.0
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = Style.shared.defaultTextColor
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Private methods
    private func setupViews() {
        self.addSubview(titleLabel)
        self.contentView.backgroundColor = Style.shared.backgroundColor
    }
    
    /// A method to configure header with provided view model
    /// - Parameter viewModel: A instance of LogoSelectorTableSectionHeaderView.ViewModel to decorate header view
    public func configure(with viewModel: ViewModel) {
        self.titleLabel.frame = CGRect(origin: CGPoint(x: Constants.Padding.horizontal, y: Constants.Padding.vertical), size: CGSize(width: self.contentView.bounds.width - (2 * Constants.Padding.horizontal), height: self.contentView.bounds.height - (2 * Constants.Padding.vertical)))
        self.titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.titleLabel.text = viewModel.title
    }
}
