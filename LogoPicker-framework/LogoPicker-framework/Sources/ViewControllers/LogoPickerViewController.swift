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

        enum Sections {
            case recentlyUsed([UIImage])
            case preview
            case logoPickerOptions([ImageSource])

            var title: String {
                switch self {
                case .recentlyUsed:
                    return "Recently Used"
                case .preview:
                    return "Preview"
                case .logoPickerOptions:
                    return "Picker Options"
                }
            }

            var itemCount: Int {
                switch self {
                case .recentlyUsed:
                    return 1
                case .preview:
                    return 1
                case .logoPickerOptions(let pickerSources):
                    return pickerSources.count
                }
            }
        }

        let logoViewModel: LogoView.ViewModel
        let title: String
        let logoFrameSize: CGSize
        var selectedLogoState: LogoState
        let sections: [Sections]

        public init(logoViewModel: LogoView.ViewModel, title: String = "Change Logo", logoFrameSize: CGSize = CGSize(width: 50, height: 50)) {
            self.logoViewModel = logoViewModel
            self.title = title
            self.logoFrameSize = logoFrameSize
            self.selectedLogoState = logoViewModel.logoState
            self.sections = [.recentlyUsed([UIImage(named: "placeholder")!]), .preview, .logoPickerOptions([.gallery, .camera])]
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

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderTopPadding = 0
        tableView.tableFooterView = nil
        return tableView
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
        registerCells()
        reloadView()
    }

    private func reloadView() {
        self.tableView.reloadData()
    }

    private func registerCells() {
        tableView.register(LogoSelectorTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: LogoSelectorTableSectionHeaderView.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(cancelButton)
        self.view.addSubview(doneButton)
        self.view.addSubview(tableView)

        self.tableView.delegate = self
        self.tableView.dataSource = self

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
        self.doneButton.frame = CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: 10), size: CGSize(width: 100, height: 44))
        self.tableView.frame = CGRect(origin: CGPoint(x: 0, y: self.doneButton.frame.maxY), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - 44.0))
    }
}

extension LogoPickerViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell else {
            fatalError("Failed to get expected kind of reusable cell from the tableView. Expected UITableViewCell")
        }

        cell.textLabel?.text = "xxx"
        return cell
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].itemCount
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LogoSelectorTableSectionHeaderView.reuseIdentifier) as? LogoSelectorTableSectionHeaderView else {
            fatalError("Could not find expected custom header view class LogoSelectorTableSectionHeaderView. Expected to find the reusable header view LogoSelectorTableSectionHeaderView for sections header")
        }
        headerView.configure(with: LogoSelectorTableSectionHeaderView.ViewModel(title: viewModel.sections[section].title, viewWidth: self.view.frame.width))

        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
}
