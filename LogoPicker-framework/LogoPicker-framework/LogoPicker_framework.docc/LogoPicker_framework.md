# ``LogoPicker framework``

## Overview
`LogoPicker_framework` is a delightful iOS image picker framework that allows its users to pick logos from available image sources

## Users
This framework will be used by all the clients who need help picking the profile/logo image in the app. All they need to do is to initialize the instance of `LogoPickerViewController` passing all the required options in the initializer and setting up a delegate to receive callbacks for completion/cancellation operations

## Architecture

### Architecture Pattern
I am using a simple view view-model-based architecture to build this framework. The view is responsible for displaying UI elements and providing a way to interact with them. The accompanying view model is responsible for applying data transformation and passing them to the view. Currently, it has no business logic, but can be added in the future as required. 

### Entry point
Framework uses the public view controller named `LogoPickerViewController` that allows users to view recent image selection, preview selection and choose images from available sources. Once selection is made, user can preview them on the same screen and finalize selection by tapping `Done` button. Users of this framework are expected to set delegate for `LogoPickerViewController` to receive callbacks once the selection is made or controller is dimissed

### UI Division
The main screen is divided into three different sections as follows,
1. Preview - To preview the selected image
2. Recently used images - Collection of recently used images. This is represented using a collection view
3. Picker options / Image sources - List of sources from which the user can select images

### Extensibility
Framework also supports future extensibility through the following additions
1. Use of table view
   The framework uses a table view to present multiple sections on the home page. Currently, it is set to show three sections. If someone wants to add more sections in the future, they can easily do so by adding and configuring sections to the existing table view

2. Use of collection view
  The framework uses a collection view to display multiple previously used images. It allows app to view and horizontally scroll through multiple images without any space constraint

3. Use of `ImageSource` enum
  App uses `ImageSource` enum to represent multiple image sources. Currently it supports picking images from gallery and camera. But can be extended to include more cases if we need to include additional sources

4. Use of `LogoFrameSize` enum
   App uses `LogoFrameSize` enum which represents the frame format for selected image. Currently it support square images, but can be extended to include additional cases to represent images in a different dimension.

5. Use of `LogoState` enum
   App uses `LogoState` enum which represents the state of logo view. Currently it support initials (In case of lack of image) and the image mode

### Custom views

#### `LogoView` components
In order to make it easy to use a similar design across screens and in the library, I have created a `LogoView` component that represents the selected logo image (Or initials in case the image is missing). It has its own view model which is used to customize it in terms of logo state, foreground color, background color, image content mode, and whether the view is tappable or not

## Framework Inclusion
To use the framework into your project, simply drag and drop the `LogoPicker-framework.framework` file into the project in Xcode. Since this framework has a dependency on Styles framework, you also need to drag and drop `Styles-framework.framework` file into your project.

Also, please make sure these frameworks are embedded into your project. For this, follow next steps,
1. Click on your project target
2. Go to General tab in Xcode
3. Under Frameworks, Libraries and Embedded Content choose "Embed and Sign" option for both of them

<img width="789" alt="Screenshot 2023-11-26 at 7 16 27 PM" src="https://github.com/jayesh15111988/LogoPicker/assets/6687735/08bd001b-11b8-43b5-a21d-058e9af3f843">

## Usage

### Importing
In order to use LogoPicker and Styles in your project, first import the framework by adding following lines on top of your source file

```swift
import LogoPicker_framework
import Styles_framework
```

### Using LogoView Component
You can initialize and display logo view on the screen by initializing `LogoView` custom view and configuring it with logo view model as follows,

For `LogoView` with title initials

```swift
let logoView = LogoView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 75, height: 75)))
logoView.configure(with: LogoViewModel(
            logoState: .title(initials: "JK"),
            backgroundColor: Style.shared.logoBackgroundColor,
            foregroundColor: Style.shared.logoForegroundColor,
            logoContentMode: .scaleAspectFill,
            tappable: true
        ))
self.view.addSubview(logoView)
```

<img width="72" alt="Screenshot 2023-11-26 at 7 22 50 PM" src="https://github.com/jayesh15111988/LogoPicker/assets/6687735/50c45c72-5f21-43ce-8417-d6811c0dbc3b">

For `LogoView` with image instance

```swift
let logoView = LogoView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 75, height: 75)))

logoView.configure(with: LogoViewModel(
            logoState: .image(logoImage: UIImage(named: "placeholder")!),
            backgroundColor: Style.shared.logoBackgroundColor,
            foregroundColor: Style.shared.logoForegroundColor,
            logoContentMode: .scaleAspectFill,
            tappable: true
        ))

self.view.addSubview(logoView)
```

<img width="67" alt="Screenshot 2023-11-26 at 7 24 47 PM" src="https://github.com/jayesh15111988/LogoPicker/assets/6687735/b90636a3-0f7f-4837-9429-514988752229">


If you want to receive a tap event on the component, make sure to pass `tappable: true` in the viewmodel and set up the component's delegate.

`logoView.delegate = <delegate_instance>`

### Using the ImagePicker Component
In order to use the image picker component, you need to instantiate and present an instance of `LogoPickerViewController`. During initialization, you can configure it using its associated view model.

```swift
let logoPickerViewController = LogoPickerViewController(
            viewModel: LogoPickerViewController.ViewModel(
                logoViewModel: LogoViewModel(
                    logoState: .title(initials: "JK"),
                    backgroundColor: Style.shared.logoBackgroundColor,
                    foregroundColor: Style.shared.logoForegroundColor,
                    logoContentMode: .scaleAspectFill),
                logoFrameSize: .square(dimension: 200)
            )
        )

// A delegate that will be called after user successfully picks the new logo image

logoPickerViewController.delegate = self
self.present(logoPickerViewController, animated: true)
```

> Don't forget to set picker controller's delegate to the appropriate instance in order to receive callback events upon operation cancellation or successful completion with the selected image

Once the image is selected or the controller is dismissed, you will receive the callback through the following two delegate methods from `LogoPickerViewControllerDelegate` protocol

```swift
public protocol LogoPickerViewControllerDelegate: AnyObject {
    func selectionCancelled()
    func selectionCompleted(logoState: LogoState)
}
```

https://github.com/jayesh15111988/LogoPicker/assets/6687735/3d03ffed-e4f6-4bfd-9503-011c1fe37ba0

##  High-level Flow diagram

![Flow_Diagram drawio](https://github.com/jayesh15111988/LogoPicker/assets/6687735/fa1633eb-fa00-40b2-aae9-c49fc7df1381)

## Third-party libraries
The framework does not use any third-party library. However, it uses the internal `Styles-framework` framework. This framework is part of the internal app ecosystem and responsible for providing styling support for the framework and client app.

## Supported Appearances
The framework supports both light and dark modes without any loss of functionality or poor user experience

## Deployment targets
The minimum deployment target for the framework is iOS 16 and supports only the portrait mode.

## Known limitations
1. The framework is currently only designed to support iOS platform. Due to complexity involved in writing similar code for AppKit, I decided to skip this part
2. Crop and resizing support - iOS does not have built-in support for cropping and resizing chosen images. Since adding this support involved complicated calculations, and I did not want to ship half-baked products, I decided to not include this feature
3. Currently, the framework has only two image sources from the device. However, users may still want to download images from remote URLs and it will be nice to add that support so that they won't be constrained by limitations of on-device asset collection
4. Currently, the framework uses a dummy cache to display recently used images. However, it is still lacking support to store them in the persistent cache that can live between app relaunches

## Potential next steps in order to ‘productionize’ the solution
1. Adding support for resizing and cropping images to improve the user experience
2. Currently framework has no support for persistent cache for recent images. I have added dummy images for demo purposes, but in the future, we still need to add support to persistently save and display recently used images without client intervention
3. I have used very basic styles and colors. However, before we release it in production, I need to work with designers to integrate better colors and themes into the framework

## Image Uploads
Once the user finalizes logo image, app can sent a request to server to update it on the back-end. When this happens, we can show loading indicator to user and replace the logo with new image once the network operation is completed. This, however will happen from outside of framework and client is responsible for sending request and updating it on the backend. The reason being, I want to keep this component limited to logo selection and notifying client of final selection.

Client is free to do any later processing on the image as necessary.

## Image Sources
Currently, app sources images from local image gallery and camera. However, support can be extended to load them from other sources such as from direct URL


