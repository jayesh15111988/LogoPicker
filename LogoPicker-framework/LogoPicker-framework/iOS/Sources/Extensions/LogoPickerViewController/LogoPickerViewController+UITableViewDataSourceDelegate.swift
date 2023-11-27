//
//  LogoPickerViewController+UITableViewDataSourceDelegate.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/26/23.
//

import UIKit
import PhotosUI

//MARK: UITableView datasource and delegate methods
extension LogoPickerViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = sections[indexPath.section]

        switch section {
        case .recentlyUsed(let logoViewModels):
            return mediaSectionCell(tableView, indexPath: indexPath, section: section, logoViewModels: logoViewModels)
        case .preview:
            return previewSectionCell(tableView, indexPath: indexPath, section: section)
        case .logoPickerOptions(let options):
            return pickerSectionCell(tableView, indexPath: indexPath, section: section, options: options)
        case .foregroundColor(let logoViewModels), .backgroundColor(let logoViewModels):
            return mediaSectionCell(tableView, indexPath: indexPath, section: section, logoViewModels: logoViewModels)
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].itemCount
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LogoSelectorTableSectionHeaderView.reuseIdentifier) as? LogoSelectorTableSectionHeaderView else {
            fatalError("Could not find expected custom header view class LogoSelectorTableSectionHeaderView. Expected to find the reusable header view LogoSelectorTableSectionHeaderView for sections header")
        }
        headerView.configure(with: LogoSelectorTableSectionHeaderView.ViewModel(title: sections[section].title))

        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.defaultSectionHeaderHeight
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]

        switch section {
        case .recentlyUsed:
            return Constants.recentImagesSectionHeight
        case .preview:
            return viewModel.logoFrameSize.height + (Constants.verticalPadding * 2)
        case .logoPickerOptions:
            return Constants.imageSourceSectionHeight
        case .foregroundColor, .backgroundColor:
            return Constants.colorsSelectionSectionHeight
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]

        switch section {
        case .recentlyUsed, .preview, .foregroundColor, .backgroundColor:
            break
        case .logoPickerOptions(let options):
            tableView.deselectRow(at: indexPath, animated: true)

            let option = options[indexPath.row]

            switch option {
            case .gallery:
                openPhotoGallery()
            case .camera:
                openCamera()
            //Add handling for more cases as necessary
            }
        }
    }

    //MARK: Private methods

    private func mediaSectionCell(_
                                         tableView: UITableView,
                                         indexPath: IndexPath,
                                         section: ViewModel.Section,
                                         logoViewModels: [LogoView.ViewModel]
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: LogoMediaTableViewCell.reuseIdentifier, for: indexPath) as? LogoMediaTableViewCell else {
            fatalError("Failed to get expected kind of reusable cell from the tableView. Expected LogoMediaTableViewCell")
        }

        cell.selectionStyle = section.selectionStyle
        cell.configure(with: logoViewModels, frameSize: .square(dimension: Constants.recentImagesSectionHeight - (2 * Constants.verticalPadding)))
        cell.imageSelectionCompletionDelegate = self
        return cell
    }

    private func previewSectionCell(_ 
                                    tableView: UITableView,
                                    indexPath: IndexPath,
                                    section: ViewModel.Section
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LogoPreviewTableViewCell.reuseIdentifier, for: indexPath) as? LogoPreviewTableViewCell else {
            fatalError("Failed to get expected kind of reusable cell from the tableView. Expected LogoPreviewTableViewCell")
        }

        cell.selectionStyle = section.selectionStyle

        cell.configure(with: updatedLogoViewModel, logoFrameSize: viewModel.logoFrameSize)
        return cell
    }

    private func pickerSectionCell(_ 
                                   tableView: UITableView,
                                   indexPath: IndexPath,
                                   section: ViewModel.Section,
                                   options: [ImageSource]
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)

        cell.selectionStyle = section.selectionStyle
        cell.textLabel?.text = options[indexPath.row].title
        return cell
    }

    private func openPhotoGallery() {
        var configuration = PHPickerConfiguration()
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
            alertDisplayUtility.showAlert(with: AlertInfo(title: "Unable to Access camera", message: "Unfortunately, app is unable to access camera of your device. Please check the device and try again"), parentViewController: self)
        }
    }

    private func presentEnableCameraPermissionPopup() {
        let cameraAccessDeniedActions: [UIAlertAction] = [UIAlertAction(title: "Dismiss", style: .cancel), UIAlertAction(title: "Check Settings", style: .default, handler: { actions in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                Router.route(to: url)
            } else {
                self.alertDisplayUtility.showAlert(with: AlertInfo(title: "Camera permission missing", message: "Please enable camera permission for app through Settings"), parentViewController: self)
            }
        })]

        alertDisplayUtility.showAlert(with: AlertInfo(title: "Unable to Access Camera", message: "The app cannot access camera on this device. Please check the camera permissions in settings", actions: cameraAccessDeniedActions), parentViewController: self)
    }

    private func presentCameraPickerViewController() {
        cameraImagePickerController.sourceType = .camera
        cameraImagePickerController.delegate = self
        self.present(cameraImagePickerController, animated: true)
    }
}
