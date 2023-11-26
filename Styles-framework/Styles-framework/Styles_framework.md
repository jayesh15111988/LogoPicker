# Styles Framework

## Summary
The styles framework is built to store all the style elements used by the app. This app will store basic style elements such as color, image assets etc. that will be shared across whole app or other libraries. 

## Integration
To integrate Styles framework into your app, simply drag and drop Styles_framework.framework file into your app and make sure set up with following app setting.

Target -> Project name -> General -> Frameworks, Libraries and Embedded Content -> Next to framework name, choose "Embed and Sign" option

## Usage
To use the styles from framework, use the `Style.shared` instance of `Style`. This will give you access to all the styles (color, images etc.) from this framework. 
For example, to access default text color, following code can be used,
`let defaultTextColor = Style.shared.defaultTextColor`
The style framework support both light and dark modes  

