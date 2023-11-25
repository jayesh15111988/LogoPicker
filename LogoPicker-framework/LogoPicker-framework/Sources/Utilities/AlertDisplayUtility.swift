//
//  AlertDisplayUtility.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit

protocol AlertDisplayable: AnyObject {
    func showAlert(with alertInfo: AlertInfo, parentViewController: UIViewController)
}

struct AlertInfo {
    let title: String
    let message: String
    let actions: [UIAlertAction]

    init(title: String, message: String, actions: [UIAlertAction] = []) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}

final class AlertDisplayUtility: AlertDisplayable {

    struct AlertInfoInQueue {
        let alertInfo: AlertInfo
        let parentViewController: UIViewController
    }

    private var alertInfoInQueue: [AlertInfoInQueue] = []
    /// A method to show an alert message
    /// - Parameters:
    ///   - title: Title to show on alert dialogue
    ///   - message: A message to display with detailed description why alert was shown
    ///   - actions: The list of actions user want to add to alertController
    ///   - parentController: A parent controller on which to show this alert dialogue
    func showAlert(with alertInfo: AlertInfo, parentViewController: UIViewController) {

        if parentViewController.presentedViewController != nil {
            alertInfoInQueue.append(AlertInfoInQueue(alertInfo: alertInfo, parentViewController: parentViewController))
            return
        }

        let alertController = UIAlertController(title: alertInfo.title, message: alertInfo.message, preferredStyle: .alert)

        if !alertInfo.actions.isEmpty {
            alertInfo.actions.forEach { alertController.addAction($0) }
        } else {
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                guard !self.alertInfoInQueue.isEmpty else {
                    return
                }
                let lastAlertInfoFromQueue = self.alertInfoInQueue.removeFirst()
                self.showAlert(with: lastAlertInfoFromQueue.alertInfo, parentViewController: lastAlertInfoFromQueue.parentViewController)
            }))
        }

        parentViewController.present(alertController, animated: true)
    }
}



