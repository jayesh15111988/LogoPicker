//
//  LogoSelectorTableSectionHeaderView.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit

final public class LogoSelectorTableSectionHeaderView: UITableViewHeaderFooterView {

    public struct ViewModel {
        let title: String
        let viewWidth: CGFloat
    }

    private enum Constants {
        enum Padding {
            static let horizontal: CGFloat = 10.0
            static let vertical: CGFloat = 10.0
        }

        enum Size {
            static let height: CGFloat = 44.0
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = Color.defaultText
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
        self.contentView.backgroundColor = Color.background
    }

    public func configure(with viewModel: ViewModel) {
        self.titleLabel.frame = CGRect(origin: CGPoint(x: Constants.Padding.horizontal, y: Constants.Padding.vertical), size: CGSize(width: viewModel.viewWidth - (2 * Constants.Padding.horizontal), height: Constants.Size.height - (2 * Constants.Padding.horizontal)))
        self.titleLabel.text = viewModel.title
    }
}

extension LogoSelectorTableSectionHeaderView: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
