//
//  LogoPickerViewController.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit
import OSLog

/// A main class for facilitating user to view, preview and select logo. This can be re-used at any place that needs replacing the logo. For example, section, teams, profile etc.
final public class LogoPickerViewController: UIViewController {

    enum Constants {
        static let verticalPadding: CGFloat = 10.0
        static let recentImagesSectionHeight: CGFloat = 84.0
        static let imageSourceSectionHeight: CGFloat = 44.0
        static let defaultSectionHeaderHeight: CGFloat = 54.0
    }

    let cameraImagePickerController = UIImagePickerController()

    let alertDisplayUtility = AlertDisplayUtility()

    static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LogoPickerViewController.self)
    )

    var updatedLogoViewModel: LogoView.ViewModel

    /// A view model to store all the business logic and related data required by this class
    public struct ViewModel {
        
        /// Sections for logo picker. Currently represents only 3 sections. Can be extended in the future as necessary
        enum Section {
            case recentlyUsed([LogoView.ViewModel])
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

            var selectionStyle: UITableViewCell.SelectionStyle {
                switch self {
                case .recentlyUsed, .preview:
                    return .none
                case .logoPickerOptions:
                    return .default
                }
            }
        }

        var logoViewModel: LogoView.ViewModel
        let title: String
        let logoFrameSize: LogoFrameSize
        var selectedLogoState: LogoState
        let sections: [Section]
        
        /// An initializer for creating an instance of LogoPickerViewController.ViewModel struct
        /// - Parameters:
        ///   - logoViewModel: A view model to be applied to LogoView
        ///   - title: A title for page
        ///   - logoFrameSize: Desired size for logo frame
        ///   - recentImages: A collection of recently used images
        public init(
            logoViewModel: LogoView.ViewModel,
            title: String = "Change Logo",
            logoFrameSize: LogoFrameSize = .square(dimension: 100),
            recentImages: [UIImage] = []
        ) {
            self.logoViewModel = logoViewModel
            self.title = title
            self.logoFrameSize = logoFrameSize
            self.selectedLogoState = logoViewModel.logoState

            let recentImagesLogoViewModels: [LogoView.ViewModel] = recentImages.map { .init(logoState: .image(logoImage: $0), backgroundColor: Color.logoBackground, foregroundColor: Color.logoForeground) }

            self.sections = [.recentlyUsed(recentImagesLogoViewModels), .preview, .logoPickerOptions([.gallery, .camera])]
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

    let viewModel: ViewModel
    public var delegate: LogoPickerViewControllerDelegate?

    //MARK: init
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.updatedLogoViewModel = viewModel.logoViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Lifecycle method
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
        registerCells()
        reloadView()
    }

    //MARK: Private methods

    private func reloadView() {
        self.tableView.reloadData()
    }
    
    /// A method to register all cells to table view
    private func registerCells() {
        tableView.register(LogoSelectorTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: LogoSelectorTableSectionHeaderView.reuseIdentifier)

        tableView.register(LogoPreviewTableViewCell.self, forCellReuseIdentifier: LogoPreviewTableViewCell.reuseIdentifier)
        tableView.register(RecentlyUsedPhotosTableViewCell.self, forCellReuseIdentifier: RecentlyUsedPhotosTableViewCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    }

    //MARK: set up views
    private func setupViews() {

        self.view.backgroundColor = Color.background
        self.view.addSubview(cancelButton)
        self.view.addSubview(doneButton)
        self.view.addSubview(tableView)

        self.tableView.delegate = self
        self.tableView.dataSource = self

        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    }

    //MARK: Layout views
    private func layoutViews() {
        self.cancelButton.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        self.doneButton.frame = CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: 0), size: CGSize(width: 100, height: 44))
        self.tableView.frame = CGRect(origin: CGPoint(x: 0, y: self.doneButton.frame.maxY), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - 44.0))
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

        delegate.selectionCompleted(logoState: updatedLogoViewModel.logoState)
    }
}

//Utility methods
extension LogoPickerViewController {

    /// A method to update preview with selected logo state
    /// - Parameter logoState: A new logo state to update preview with
    func updatePreview(with logoState: LogoState) {
        let oldViewModel = self.updatedLogoViewModel
        self.updatedLogoViewModel = LogoView.ViewModel(logoState: logoState, backgroundColor: oldViewModel.backgroundColor, foregroundColor: oldViewModel.foregroundColor, logoContentMode: oldViewModel.logoContentMode, tappable: oldViewModel.tappable)

        if let previewSectionIndex = self.viewModel.sections.firstIndex(where: {
            if case .preview = $0 {
                return true
            }
            return false
        }) {
            DispatchQueue.main.async {
                self.tableView.reloadSections([previewSectionIndex], with: .none)
            }
        }
    }
}

//MARK: ImageSelectionCompletionDelegate delegate
extension LogoPickerViewController: ImageSelectionCompletionDelegate {

    /// A delegate method to call after image is selected
    /// - Parameter state: A new logo state
    func imageSelected(state: LogoState) {
        updatePreview(with: state)
    }
}
