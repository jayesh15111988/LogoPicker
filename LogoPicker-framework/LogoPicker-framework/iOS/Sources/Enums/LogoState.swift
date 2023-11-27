//
//  LogoState.swift
//  LogoPicker-framework
//
//  Created by Jayesh Kawli on 11/25/23.
//

import UIKit

/// An enum to encode the logo state. It currently has two forms. First, showing initials and second, an actual image
public enum LogoState {

    public struct ImageViewModel {
        let image: UIImage
        let contentMode: UIView.ContentMode

        public init(image: UIImage, contentMode: UIView.ContentMode = .scaleAspectFill) {
            self.image = image
            self.contentMode = contentMode
        }
    }

    public struct InitialsViewModel {
        let name: String
        let titleColor: UIColor
        let backgroundColor: UIColor

        public init(name: String, titleColor: UIColor, backgroundColor: UIColor) {
            self.name = name
            self.titleColor = titleColor
            self.backgroundColor = backgroundColor
        }

        var initials: String {
            return name.initials
        }
    }

    public struct ColorViewModel {

        public enum ColorType {
            case foreground
            case background
        }

        let color: UIColor
        let type: ColorType

        public init(color: UIColor, type: ColorType) {
            self.color = color
            self.type = type
        }
    }

    case initials(viewModel: InitialsViewModel)
    case image(viewModel: ImageViewModel)
    case color(viewModel: ColorViewModel)

    func cornerRadius(for width: CGFloat) -> CGFloat {
        switch self {
        case .initials:
            return width / 4.0
        case .image, .color:
            return width / 2.0
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .initials, .color:
            return nil
        case .image(let logoImage):
            return logoImage.image
        }
    }

    var contentMode: UIView.ContentMode? {
        switch self {
        case .initials, .color:
            return nil
        case .image(let logoImage):
            return logoImage.contentMode
        }
    }

    var foregroundColor: UIColor? {
        switch self {
        case .image, .color:
            return nil
        case .initials(let viewModel):
            return viewModel.titleColor
        }
    }

    var backgroundColor: UIColor? {
        switch self {
        case .image, .color:
            return nil
        case .initials(let viewModel):
            return viewModel.backgroundColor
        }
    }

    var name: String? {
        switch self {
        case .image, .color:
            return nil
        case .initials(let viewModel):
            return viewModel.name
        }
    }

}

//Source: https://stackoverflow.com/a/64576199
extension String {
    var initials: String {
        return self.components(separatedBy: " ")
            .filter { !$0.isEmpty }
            .reduce("") {
                ($0.isEmpty ? "" : "\($0.first?.uppercased() ?? "")") +
                ($1.isEmpty ? "" : "\($1.first?.uppercased() ?? "")")
            }
    }
}
