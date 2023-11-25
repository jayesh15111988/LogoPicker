//
//  ViewController.swift
//  LogoPicker-iOS
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit
import LogoPicker_framework

typealias ViewModel = LogoView.ViewModel

class ViewController: UIViewController {

    private let logoView: LogoView = {
        let logoView = LogoView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50, height: 50)))
        return logoView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        
        logoView.delegate = self

        self.view.addSubview(logoView)
        logoView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        logoView.configure(with: ViewModel(logoState: .title(initials: "JK"), backgroundColor: .blue, foregroundColor: .white, logoContentMode: .scaleAspectFit))
    }
}

extension ViewController: TapEventHandalable {
    func logoViewTapped() {

    }
}

