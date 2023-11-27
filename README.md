# ``LogoPicker framework``

## Overview
`LogoPicker_framework` is a delightful iOS image picker framework that allows its users to pick logos from available image sources and stylize their initials

## Users
This framework will be used by all the clients who need help picking the profile/logo image or stylize the section name initials in the app. All they need to do is to initialize the instance of `LogoPickerViewController` passing all the required options in the initializer and setting up a delegate to receive callbacks for completion/cancellation operations

## Running the app
To run the app, open `LogoPicker.xcworkspace` in the Xcode, select target `LogoPicker-iOS`, choose the appropriate destination and hit run or press `cmd + R` to run the demo project.

## Architecture

## Source code
The source code for `LogoPicker` framework is situated under `LogoPicker-framework` target in `LogoPicker.xcworkspace` workspace. The workspace also has another framework named `Styles-framework` that provides styles used by the app and the framework.

### Architecture Pattern
I am using a simple view view-model-based architecture to build the `LogoPicker-framework` framework. The view is responsible for displaying UI elements and providing a way to interact with them. The accompanying view model is responsible for applying data transformation and passing transformed data and computed properties to the view. Currently, it has some business logic and can be extended in the future as required. 

### Entry point
Framework uses the public view controller named `LogoPickerViewController` that allows users to view recent image selection, preview selection, choose images from available source and stylize initials. Once the selection is made, user can preview them on the same screen and finalize selection by tapping `Done` button. Users of this framework are expected to set delegate for `LogoPickerViewController` to receive callbacks once the selection is made. User can then utilize provided media type as per their requirements.

### UI Structure
The main screen is divided into three different sections based on the input logo type as follows,

For image logo selection
1. Preview - To preview the selected image
2. Recently used images - Collection of recently used images. 
3. Picker options / Image sources - List of sources which the user can select images from

For stylizing initials
1. Preview - To preview how stylized initials look like based on style selection
2. Foreground colors - The list of foreground colors that can be applied to initials text
3. Background colors - The list of background colors that can be applied to the initials background view

### Extensibility
Framework also supports future extensibility through the following additions
1. Use of table view
   The framework uses a table view to present multiple sections on the logo picker home page. Currently, it is set to show three sections. If someone wants to add more sections in the future, they can easily do so by adding more cases to `Section` enum and adding and configuring sections to the existing table view

2. Use of collection view
  The framework uses a collection view to display multiple media items. It allows app to view and horizontally scroll through multiple media without any space constraint. 

3. Use of `ImageSource` enum
  App uses `ImageSource` enum to represent multiple image sources. Currently it supports picking images from gallery and camera. But can be extended to include more cases if we need to include additional sources

4. Use of `LogoFrameSize` enum
   App uses `LogoFrameSize` enum which represents the frame format for selected image. Currently it support square images, but can be extended to include additional cases to represent images in a different dimension.

5. Use of `LogoState` enum
   App uses `LogoState` enum which represents the state of logo view. Currently it support initials (In case of lack of image), image mode and color modes.

### Custom views

#### `LogoView` components
In order to make it easy to use a similar design across screens and in the library, I have created a `LogoView` component that represents the selected logo image (Or initials or solid colors). It has its own view model which is used to customize it in terms of logo state, foreground color, background color, image content mode, and whether the view is tappable or not

## Framework Inclusion
To use the framework into your project, simply drag and drop the `LogoPicker-framework.framework` file into the project in Xcode. Since this framework has a dependency on Styles framework, you also need to drag and drop `Styles-framework.framework` file into your project.

Also, please make sure these frameworks are embedded into your project. For this, follow next steps,
1. Click on your project target
2. Go to the General tab in Xcode
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

logoView.configure(with:
                    LogoViewModel(
                        logoState: .initials(
                            viewModel: LogoState.InitialsViewModel(
                                name: "John Karmarkar",
                                titleColor: .white,
                                backgroundColor: .black)
                        ),
                        tappable: true)
)

self.view.addSubview(logoView)
```

<img width="72" alt="Screenshot 2023-11-26 at 7 22 50 PM" src="https://github.com/jayesh15111988/LogoPicker/assets/6687735/50c45c72-5f21-43ce-8417-d6811c0dbc3b">

For `LogoView` with image instance

```swift
let logoView = LogoView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 75, height: 75)))

logoView.configure(with:
                    LogoViewModel(
                        logoState: .image(viewModel: LogoState.ImageViewModel(image: Style.shared.profilePlaceholder, contentMode: .scaleAspectFill)),
                        tappable: true)

self.view.addSubview(logoView)
```

<img width="67" alt="Screenshot 2023-11-26 at 7 24 47 PM" src="https://github.com/jayesh15111988/LogoPicker/assets/6687735/b90636a3-0f7f-4837-9429-514988752229">


If you want to receive a tap event on the component, make sure to pass `tappable: true` in the viewmodel and set up the component's delegate.

`logoView.delegate = <delegate_instance>`

### Using the ImagePicker Component
In order to use the image picker component, you need to instantiate and present an instance of `LogoPickerViewController`. During initialization, you can configure it using its associated view model.

```swift
//The main logo picker view controller which will allow users to choose the logo image of their choice

let logoPickerViewModel = LogoPickerViewController.ViewModel(
    logoViewModel: LogoViewModel(logoState: logoState),
    title: "Robert Langdon",
    logoFrameSize: .square(dimension: 150)
)

let logoPickerViewController = LogoPickerViewController(viewModel: logoPickerViewModel)

//A delegate that will be called after user successfully picks the new logo image. User needs to dismiss the view by themselves to proceed.

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

https://github.com/jayesh15111988/LogoPicker/assets/6687735/4decb9e7-380e-4ac9-920a-651d797ca448

##  High-level Flow diagram

![Flow_Diagram drawio](https://github.com/jayesh15111988/LogoPicker/assets/6687735/fa1633eb-fa00-40b2-aae9-c49fc7df1381)

## Third-party libraries
The framework does not use any third-party library. However, it uses the internal `Styles-framework` framework. This framework is part of the internal app ecosystem and responsible for providing styling support for the framework and client app.

## Supported Appearances
The framework supports both light and dark modes without any loss of functionality

## Deployment Targets
The minimum deployment target for the framework is iOS 16

## Display Mode
Framework currently supports only the portrait mode.

## Known limitations
1. The framework is currently only designed to support iOS platform. Due to the complexity involved in writing similar code for AppKit, I decided to skip this part
2. Crop and resizing support - iOS does not have built-in support for cropping and resizing chosen images. Since adding this support involved complicated calculations, and I did not want to ship half-baked products, I decided to not include this feature
3. Currently, the framework has only two image sources from the device. However, users may still want to download images from remote URLs and it will be nice to add that support so that they won't be constrained by limitations of on-device asset collection
4. Currently, the framework uses a dummy cache to display recently used images. However, it is still lacking support to store them in the persistent cache that can live between app relaunches
5. App does not allow users to change font for stylized initials. This could be a good future improvement for better control over customization
6. The app is only supported in the portrait mode. However, support could be added to support landscape mode in the future

## Potential next steps in order to ‘productionize’ the solution
1. Adding support for resizing and cropping images to improve the user experience
2. Currently framework has no support for persistent cache for recent images. I have added dummy images for demo purposes, but in the future, we still need to add support to persistently save and display recently used images without client intervention
3. I have used very basic styles and colors. However, before we release it in production, I need to work with designers to integrate better colors and themes into the framework
4. Support for landscape mode needs to be added before releasing it in the production
5. Currently, the framework does not have any tests (Unit/Snapshot/UI). But it can be made more resilient and robust by adding a comprehensive test coverage

## Image Uploads
Once the user finalizes the profile logo (In the form of `LogoState`), app can send a request to server to update it on the back-end. When this happens, we can show loading indicator to user and replace the logo with new image once the network operation is completed. This, however will happen from outside of framework and client is responsible for sending request and updating them on the backend. The reason being, I wanted to keep this component limited to media selection and notifying client of final action.

Currently, `LogoState` takes two forms
1. Initials
2. Image

In case of initials, app can encode the metadata (name, color styles) and send it to the server. In case of image media, app can encode image data and upload it on the server and get the remote URL back. 

At one point, user logo can have only one state - Meaning it won't have both stylized initials and a profile image. Since both these formats follow different conventions, they will be encoded separately in the incoming response. It is the client's responsibility to infer it and convert this data into a `LogoState` enum

## Image Sources
Currently, app sources images from local image gallery and camera. However, support can be extended to load them from other sources such as from direct URL.
In case of initials, they are derived from the title of the page image picker is triggered from and we expect the client to provide them while initializing `LogoPickerViewController` screen

## Third party images
The app uses image sources from following third-party websites

https://www.shareicon.net/stick-man-profile-circle-avatar-people-724703
https://www.flaticon.com/free-icon/image_739249?term=placeholder&page=1&position=3&origin=tag&related_id=739249
