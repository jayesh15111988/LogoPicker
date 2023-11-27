//
//  LogoPickerViewController.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit
import OSLog

import Styles_framework

/// A main class for facilitating user to view, preview and select logo. This can be re-used at any place that needs replacing the logo. For example, section, teams, profile etc.
final public class LogoPickerViewController: UIViewController {

    enum Constants {
        static let verticalPadding: CGFloat = 10.0
        static let recentImagesSectionHeight: CGFloat = 84.0
        static let imageSourceSectionHeight: CGFloat = 44.0
        static let defaultSectionHeaderHeight: CGFloat = 54.0
        static let colorsSelectionSectionHeight: CGFloat = 84.0
    }

    let cameraImagePickerController = UIImagePickerController()

    //An utility to show alert message to user
    let alertDisplayUtility = AlertDisplayUtility()

    static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LogoPickerViewController.self)
    )

    //A view model to keep track of changed app state
    var updatedLogoViewModel: LogoView.ViewModel

    /// A view model to store all the business logic and related data required by this class
    public struct ViewModel {
        
        /// Sections for logo picker. Currently represents 5 sections. Can be extended in the future as necessary. The sections are displayed according to current logo picker mode
        enum Section {
            case recentlyUsed([LogoView.ViewModel])
            case preview
            case logoPickerOptions([ImageSource])
            case foregroundColor([LogoView.ViewModel])
            case backgroundColor([LogoView.ViewModel])

            var title: String {
                switch self {
                case .recentlyUsed:
                    return "Recently Used"
                case .preview:
                    return "Preview"
                case .logoPickerOptions:
                    return "Picker Options"
                case .foregroundColor:
                    return "Initials Title Color"
                case .backgroundColor:
                    return "Initials Background Color"
                }
            }

            var itemCount: Int {
                switch self {
                case .recentlyUsed, .preview, .foregroundColor, .backgroundColor:
                    return 1
                case .logoPickerOptions(let pickerSources):
                    return pickerSources.count
                }
            }

            var selectionStyle: UITableViewCell.SelectionStyle {
                switch self {
                case .recentlyUsed, .preview, .foregroundColor, .backgroundColor:
                    return .none
                case .logoPickerOptions:
                    return .default
                }
            }
        }

        let logoViewModel: LogoView.ViewModel
        let title: String
        let logoFrameSize: LogoFrameSize

        let initialsLogoState: LogoState
        let imageLogoState: LogoState

        let selectedSegmentIndexState: SegmentIndexState

        /// An initializer for creating an instance of LogoPickerViewController.ViewModel struct
        /// - Parameters:
        ///   - logoViewModel: A view model to be applied to LogoView
        ///   - title: A client title page
        ///   - logoFrameSize: Desired size for logo frame
        public init(
            logoViewModel: LogoView.ViewModel,
            title: String,
            logoFrameSize: LogoFrameSize = .square(dimension: 150)
        ) {
            self.logoViewModel = logoViewModel
            self.title = title
            self.logoFrameSize = logoFrameSize

            let currentLogoState = logoViewModel.logoState

            switch currentLogoState {
            case .initials:
                self.initialsLogoState = currentLogoState
                self.imageLogoState = .image(viewModel: .init(image: Style.shared.profilePlaceholder))
                selectedSegmentIndexState = .initials
            case .image:
                self.imageLogoState = currentLogoState
                self.initialsLogoState = .initials(viewModel: .init(name: title, titleColor: Style.shared.logoForegroundColor, backgroundColor: Style.shared.logoBackgroundColor))
                selectedSegmentIndexState = .images
            case .color:
                fatalError("Unexpected state. The program flow should never reach at this point during view model initialization")
            }
        }

        // An enum to represent currently chosen segment index
        enum SegmentIndexState: Int {
            case initials
            case images
        }

        func getSections(for selectedState: SegmentIndexState) -> [Section] {
            switch selectedState {
            case .initials:

                //Dummy foreground and background colors in the app
                let randomForegroundColors = ColorProviderUtility.foregroundColors()
                let randomBackgroundColors = ColorProviderUtility.backgroundColors()

                let foregroundColorViewModels: [LogoView.ViewModel] = randomForegroundColors.map {
                    .init(logoState: .color(viewModel: .init(color: $0, type: .foreground)))
                }

                let backgroundColorViewModels: [LogoView.ViewModel] = randomBackgroundColors.map {
                    .init(logoState: .color(viewModel: .init(color: $0, type: .background)))
                }

                return [
                    .preview,
                    .foregroundColor(foregroundColorViewModels),
                    .backgroundColor(backgroundColorViewModels)
                ]
            case .images:

                let recentImages = ImageCache.shared.recentImages()

                let recentImagesLogoViewModels: [LogoView.ViewModel] = recentImages.map {
                    LogoView.ViewModel(logoState: .image(viewModel: LogoState.ImageViewModel(image: $0))
                    )
                }

                return [
                    .preview,
                    .recentlyUsed(recentImagesLogoViewModels),
                    .logoPickerOptions([.gallery, .camera])
                ]
            }
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

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderTopPadding = 0
        tableView.tableFooterView = nil
        return tableView
    }()

    private let segmentedControl = UISegmentedControl(frame: .zero)

    let viewModel: ViewModel
    public var delegate: LogoPickerViewControllerDelegate?

    var selectedImageLogoState: LogoState
    var selectedInitialsLogoState: LogoState

    var sections: [ViewModel.Section] = []

    //MARK: init
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.updatedLogoViewModel = viewModel.logoViewModel

        self.selectedInitialsLogoState = viewModel.initialsLogoState
        self.selectedImageLogoState = viewModel.imageLogoState

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
        refreshView(for: viewModel.selectedSegmentIndexState)
    }

    //MARK: Private methods
    
    /// A method to register all cells to table view
    private func registerCells() {

        tableView.register(LogoSelectorTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: LogoSelectorTableSectionHeaderView.reuseIdentifier)

        tableView.register(LogoPreviewTableViewCell.self, forCellReuseIdentifier: LogoPreviewTableViewCell.reuseIdentifier)
        tableView.register(LogoMediaTableViewCell.self, forCellReuseIdentifier: LogoMediaTableViewCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    }

    //MARK: set up views
    private func setupViews() {

        self.view.backgroundColor = Style.shared.backgroundColor
        self.view.addSubview(cancelButton)
        self.view.addSubview(doneButton)
        self.view.addSubview(tableView)

        self.tableView.delegate = self
        self.tableView.dataSource = self

        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)

        segmentedControl.insertSegment(withTitle: "Initials", at: ViewModel.SegmentIndexState.initials.rawValue, animated: false)

        segmentedControl.insertSegment(withTitle: "Image", at: ViewModel.SegmentIndexState.images.rawValue, animated: false)

        segmentedControl.selectedSegmentIndex = viewModel.selectedSegmentIndexState.rawValue

        self.view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
    }

    //MARK: Layout views
    private func layoutViews() {

        let topParentYOffset: CGFloat = 64.0
        let innerYOffset: CGFloat = 44.0
        let bottomYOffset: CGFloat = 20.0

        let totalYOffset = topParentYOffset + innerYOffset + bottomYOffset

        self.cancelButton.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        self.doneButton.frame = CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: 0), size: CGSize(width: 100, height: 44))

        self.segmentedControl.frame = CGRect(origin: CGPoint(x: 0, y: self.doneButton.frame.maxY), size: CGSize(width: self.view.bounds.width, height: 44.0))

        self.tableView.frame = CGRect(origin: CGPoint(x: 0, y: self.segmentedControl.frame.maxY), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - totalYOffset))
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

    @objc private func segmentedControlTapped(_ segmentedControl: UISegmentedControl) {

        let selectedIndex = segmentedControl.selectedSegmentIndex

        guard let selectedIndexType = ViewModel.SegmentIndexState(rawValue: selectedIndex) else {
            Self.logger.error("App has allowed user to choose an invalid segment control index. App has entered an invalid state. Unable to proceed with state and UI update operation")
            return
        }

        refreshView(for: selectedIndexType)
    }

    private func refreshView(for selectedIndexType: ViewModel.SegmentIndexState) {
        let newLogoState: LogoState
        switch selectedIndexType {
        case .initials:
            newLogoState = selectedInitialsLogoState
        case .images:
            newLogoState = selectedImageLogoState
        }

        self.updatedLogoViewModel = LogoView.ViewModel(logoState: newLogoState, tappable: self.updatedLogoViewModel.tappable)

        sections = viewModel.getSections(for: selectedIndexType)
        self.tableView.reloadData()
    }
}
