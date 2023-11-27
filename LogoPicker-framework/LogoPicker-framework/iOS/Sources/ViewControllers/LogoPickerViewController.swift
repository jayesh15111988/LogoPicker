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

        let initialsLogoState: LogoState?
        let imageLogoState: LogoState?

        var showingSegmentedControl: Bool {
            return initialsLogoState != nil
        }

        /// An initializer for creating an instance of LogoPickerViewController.ViewModel struct
        /// - Parameters:
        ///   - logoViewModel: A view model to be applied to LogoView
        ///   - title: A title for page
        ///   - logoFrameSize: Desired size for logo frame
        public init(
            logoViewModel: LogoView.ViewModel,
            title: String = "Change Logo",
            logoFrameSize: LogoFrameSize = .square(dimension: 150)
        ) {
            self.logoViewModel = logoViewModel
            self.title = title
            self.logoFrameSize = logoFrameSize

            let currentLogoState = logoViewModel.logoState

            switch currentLogoState {
            case .initials:
                self.initialsLogoState = currentLogoState
                self.imageLogoState = nil
            case .image:
                self.imageLogoState = currentLogoState
                self.initialsLogoState = nil
            case .color:
                fatalError("Unexpected state. The program flow should never reach at this point during view model initialization")
            }
        }

        enum SegmentIndexState: Int {
            case initials
            case images
        }

        func getSections(for selectedState: SegmentIndexState) -> [Section] {
            switch selectedState {
            case .initials:

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

        func getInitialSections() -> [Section] {
            if self.showingSegmentedControl {
                return getSections(for: .initials)
            } else {
                return getSections(for: .images)
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

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderTopPadding = 0
        tableView.tableFooterView = nil
        return tableView
    }()

    private let segmentedControl = UISegmentedControl(frame: .zero)

    let viewModel: ViewModel
    public var delegate: LogoPickerViewControllerDelegate?

    var selectedImageLogoState: LogoState?
    var selectedInitialsLogoState: LogoState?

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
        reloadView()
    }

    //MARK: Private methods

    private func reloadView() {
        sections = viewModel.getInitialSections()
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

        self.view.backgroundColor = Style.shared.backgroundColor
        self.view.addSubview(cancelButton)
        self.view.addSubview(doneButton)
        self.view.addSubview(tableView)

        self.tableView.delegate = self
        self.tableView.dataSource = self

        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)

        if self.viewModel.showingSegmentedControl {

            segmentedControl.insertSegment(withTitle: "Initials", at: 0, animated: false)
            segmentedControl.insertSegment(withTitle: "Image", at: 1, animated: false)

            segmentedControl.selectedSegmentIndex = 0
            self.view.addSubview(segmentedControl)
            segmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
        }
    }

    //MARK: Layout views
    private func layoutViews() {

        let topParentYOffset: CGFloat = 64.0
        let innerYOffset: CGFloat = 44.0
        let bottomYOffset: CGFloat = 20.0

        let totalYOffset = topParentYOffset + innerYOffset + bottomYOffset

        self.cancelButton.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        self.doneButton.frame = CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: 0), size: CGSize(width: 100, height: 44))

        let tableViewYOffset: CGFloat

        if self.viewModel.showingSegmentedControl {
            self.segmentedControl.frame = CGRect(origin: CGPoint(x: 0, y: self.doneButton.frame.maxY), size: CGSize(width: self.view.bounds.width, height: 44.0))
            tableViewYOffset = self.segmentedControl.frame.maxY
        } else {
            tableViewYOffset = self.doneButton.frame.maxY
        }

        self.tableView.frame = CGRect(origin: CGPoint(x: 0, y: tableViewYOffset), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - totalYOffset))
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

        var newLogoState: LogoState?
        switch selectedIndexType {
        case .initials:
            newLogoState = selectedInitialsLogoState
        case .images:
            if let selectedImageLogoState {
                newLogoState = selectedImageLogoState
            } else {
                //Placeholder image view in case no selection has yet been made
                newLogoState = .image(viewModel: .init(image: Style.shared.profilePlaceholder))
            }
        }

        if let newLogoState {
            self.updatedLogoViewModel = LogoView.ViewModel(logoState: newLogoState, tappable: self.updatedLogoViewModel.tappable)
        }

        sections = viewModel.getSections(for: selectedIndexType)
        self.tableView.reloadData()
    }
}

//Utility methods
extension LogoPickerViewController {

    /// A method to update preview with selected logo state
    /// - Parameter logoState: A new logo state to update preview with
    func updatePreview(with logoState: LogoState) {

        let newLogoState: LogoState
        let oldViewModel = self.updatedLogoViewModel

        switch logoState {
        case .initials:
            fatalError("Unexpected program flow. The control should never reach here once the media is updated")
            break
        case .image:
            guard let previousContentMode = logoState.contentMode, let selectedImage = logoState.selectedImage else {
                Self.logger.error("Application must have initial selected image and content mode if the user has selected image. The app has entered an invalid state. Unable to proceed")
                return
            }
            newLogoState = LogoState.image(viewModel: .init(image: selectedImage, contentMode: previousContentMode))
            self.selectedImageLogoState = newLogoState
        case .color(let viewModel):
            guard let selectedInitialsLogoState else {
                Self.logger.error("Application must have initials logo state if the user has selected colors. The app has entered an invalid state. Unable to proceed")
                return
            }

            guard
                let previousForegroundColor = selectedInitialsLogoState.foregroundColor,
                    let previousBackgroundColor = selectedInitialsLogoState.backgroundColor, let name = selectedInitialsLogoState.name else {

                    return
                  }

            let newForegroundColor = viewModel.type == .foreground ? viewModel.color : previousForegroundColor

            let newBackgroundColor = viewModel.type == .background ? viewModel.color : previousBackgroundColor

            newLogoState = LogoState.initials(viewModel: LogoState.InitialsViewModel(name: name, titleColor: newForegroundColor, backgroundColor: newBackgroundColor))
            self.selectedInitialsLogoState = newLogoState
        }

        self.updatedLogoViewModel = LogoView.ViewModel(logoState: newLogoState, tappable: oldViewModel.tappable)

        if let previewSectionIndex = self.sections.firstIndex(where: {
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
