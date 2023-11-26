//
//  LogoPickerViewController.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit
import PhotosUI
import OSLog

public protocol LogoPickerViewControllerDelegate: AnyObject {
    func selectionCancelled()
    func selectionCompleted(logoState: LogoState)
}

public class LogoPickerViewController: UIViewController {

    enum Constants {
        static let verticalPadding: CGFloat = 10.0
    }

    private let cameraImagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: LogoPickerViewController.self)
    )

    var updatedLogoViewModel: LogoView.ViewModel

    public struct ViewModel {

        enum Sections {
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
                case .recentlyUsed:
                    return .none
                case .preview:
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
        let sections: [Sections]

        public init(logoViewModel: LogoView.ViewModel, title: String = "Change Logo", logoFrameSize: LogoFrameSize = .square(dimension: 100), recentImages: [UIImage] = []) {
            self.logoViewModel = logoViewModel
            self.title = title
            self.logoFrameSize = logoFrameSize
            self.selectedLogoState = logoViewModel.logoState

            let recentImagesLogoViewModels: [LogoView.ViewModel] = recentImages.map { .init(logoState: .image(logoImage: $0), backgroundColor: .lightGray, foregroundColor: .clear) }

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

    private let viewModel: ViewModel
    public var delegate: LogoPickerViewControllerDelegate?

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.updatedLogoViewModel = viewModel.logoViewModel
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

        tableView.register(LogoPreviewTableViewCell.self, forCellReuseIdentifier: LogoPreviewTableViewCell.reuseIdentifier)
        tableView.register(RecentlyUsedPhotosTableViewCell.self, forCellReuseIdentifier: RecentlyUsedPhotosTableViewCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
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

        delegate.selectionCompleted(logoState: updatedLogoViewModel.logoState)
    }

    private func layoutViews() {
        self.cancelButton.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        self.doneButton.frame = CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: 0), size: CGSize(width: 100, height: 44))
        self.tableView.frame = CGRect(origin: CGPoint(x: 0, y: self.doneButton.frame.maxY), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - 44.0))
    }
}

extension LogoPickerViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = viewModel.sections[indexPath.section]

        switch section {
        case .recentlyUsed(let logoViewModels):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentlyUsedPhotosTableViewCell.reuseIdentifier, for: indexPath) as? RecentlyUsedPhotosTableViewCell else {
                fatalError("Failed to get expected kind of reusable cell from the tableView. Expected RecentlyUsedPhotosTableViewCell")
            }

            cell.selectionStyle = section.selectionStyle
            cell.configure(with: logoViewModels)
            cell.imageSelectionCompletionDelegate = self
            return cell
        case .preview:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LogoPreviewTableViewCell.reuseIdentifier, for: indexPath) as? LogoPreviewTableViewCell else {
                fatalError("Failed to get expected kind of reusable cell from the tableView. Expected LogoPreviewTableViewCell")
            }

            cell.selectionStyle = section.selectionStyle

            cell.configure(with: updatedLogoViewModel, logoFrameSize: viewModel.logoFrameSize)
            return cell
        case .logoPickerOptions(let options):
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)

            cell.selectionStyle = section.selectionStyle
            cell.textLabel?.text = options[indexPath.row].title
            return cell
        }
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

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.sections[indexPath.section]

        switch section {
        case .recentlyUsed:
            return 84
        case .preview:
            return viewModel.logoFrameSize.height + (Constants.verticalPadding * 2)
        case .logoPickerOptions:
            return 44
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]

        switch section {
        case .recentlyUsed, .preview:
            break
        case .logoPickerOptions(let options):
            tableView.deselectRow(at: indexPath, animated: true)

            let option = options[indexPath.row]

            switch option {
            case .gallery:
                openPhotoGallery()
            case .camera:
                openCamera()
            // Add handling for more cases as necessary
            }
        }
    }

    private func openPhotoGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }

    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                presentCameraPickerViewController()
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    DispatchQueue.main.async {
                        if granted {
                            self.presentCameraPickerViewController()
                        } else {
                            self.presentEnableCameraPermissionPopup()
                        }
                    }
                })
            }
        } else {
            AlertDisplayUtility().showAlert(with: AlertInfo(title: "Unable to Access camera", message: "Unfortunately, app is unable to access camera of your device. Please check the device and try again"), parentViewController: self)
        }
    }

    private func presentEnableCameraPermissionPopup() {
        let cameraAccessDeniedActions: [UIAlertAction] = [UIAlertAction(title: "Dismiss", style: .cancel), UIAlertAction(title: "Check Settings", style: .default, handler: { actions in
            if let url = URL(string:UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })]

        AlertDisplayUtility().showAlert(with: AlertInfo(title: "Unable to Access Camera", message: "The app cannot access camera on this device. Please check the camera permissions in settings", actions: cameraAccessDeniedActions), parentViewController: self)
    }

    private func presentCameraPickerViewController() {
        cameraImagePickerController.sourceType = .camera
        cameraImagePickerController.delegate = self
        self.present(cameraImagePickerController, animated: true)
    }
}

extension LogoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            AlertDisplayUtility().showAlert(with: AlertInfo(title: "Unable to get image", message: "App is unable to get the clicked image. Please try again."), parentViewController: self)
            return
        }
        updatePreview(with: .image(logoImage: image))
    }
}

extension LogoPickerViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        if let itemProvider = results.first?.itemProvider {
            if itemProvider.canLoadObject(ofClass: UIImage.self){
                itemProvider.loadObject(ofClass: UIImage.self) { image , error  in
                    if let error {
                        AlertDisplayUtility().showAlert(with: AlertInfo(title: "Unable to load selected image", message: "App is unable to load selected image due to an error \(error.localizedDescription)"), parentViewController: self)
                    }
                    if let selectedImage = image as? UIImage{
                        self.updatePreview(with: .image(logoImage: selectedImage))
                    }
                }
            }
        }
    }
}

//Utility methods
extension LogoPickerViewController {
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

extension LogoPickerViewController: ImageSelectionCompletionDelegate {
    func imageSelected(state: LogoState) {
        updatePreview(with: state)
    }
}
