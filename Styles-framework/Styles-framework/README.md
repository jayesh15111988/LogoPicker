# Styles Framework

## Summary
The styles framework is used to store all the style elements used by the app. This app will store basic style elements such as color, image assets etc. that will be shared across whole app or other libraries within the same ecosystem. 

## Integration
To integrate Styles framework into your app, simply drag and drop Styles_framework.framework file into your app and make sure set up with following app setting.

Target -> Project name -> General -> Frameworks, Libraries and Embedded Content -> Next to framework name, choose "Embed and Sign" option

<img width="784" alt="Screenshot 2023-11-26 at 6 29 28 PM" src="https://github.com/jayesh15111988/LogoPicker/assets/6687735/9a279cd2-282e-4c05-a7ff-8314bffe1d1d">

## Usage
To use the styles from framework, use the `Style.shared` instance of `Style`. This will give you access to all the styles (color, images etc.) from this framework. 
For example, to access default text color, following code can be used,
`let defaultTextColor = Style.shared.defaultTextColor`

To access image from Styles framework, please use the following code,
```swift
import Styles_framework
let genericPlaceholderImage = Style.shared.profilePlaceholder
```
The style framework support both light and dark modes  

