# CBPhotoPicker
A customizable photo picker view controller for iOS -- Swift


## Setup
### Initial Setup Instructions
1. Ensure you have the latest version of Xcode installed on your computer. You can find the latest release at https://developer.apple.com/xcode/downloads/
2. Install cocoapods to your Mac by opening Terminal and executing the command
  > sudo gem install cocoapods

### Cocoa Pod Instructions
1. Add `pod 'CBPhotoPicker'` to your Podfile

2. Run `pod install`

## Usage
### Initial Setup Instructions
At the top of the file where you'd like to use `CBPhotoPicker`, insert `import CBPhotoPicker`

### Initialization
Create a photo picker by instantiating a photo picker view controller. 

In code, that would be:

```
let photoPicker = CBPhotoPickerViewController(frame: view.frame, aspectRatio: 1)
photoPicker.delegate = self
self.presentViewController(photoPicker, animated: true, completion: {})
```

This will present a photo picker with an aspect ratio of the picked image as 1:1. 

As of right now, if you don't provide you're own dismissal strategy, triple tap will dismiss the photo picker

### Delegate
The class presenting the above photo picker needs to conforming to `CBPhotoPickerViewControllerDelegate` protocol, which involves two methods. The `handleCancel()` method right now doesn't do anything, but the `handleSuccess` method will properly give you the result image when the photo picker is dismissed. 


## CHANGELOG
### v0.1.7
Added a push behavior to bring all images that go off screen back into the view. I think there is a bug where if it's zoomed in you lose the zoom state, but otherwise it works! 

### v0.1.8
BREAKING CHANGES -- you now need to add 2 parameters to your calls to initialize a `CBPhotoPickerViewController`.

```
let photoPicker = CBPhotoPickerViewController(frame: view.frame, aspectRatio: 1, placeholder: nil, cbPhotoPickerStyle: style)
photoPicker.delegate = self
self.presentViewController(photoPicker, animated: true, completion: {})
```

The placeholder image is what is shown to your users before they choose an image. The style parameter is required, but a default style is provided. To get the style, just do:

```
let style = CBPhotoPickerStyle.defaultStyle()
```

Alternatively, if you want to customize the appearance of the photo picker (so far we've only opened up the tintColor for text/buttons, and the selectionColor of the image cells)

```
let style = CBPhotoPickerStyle.customStyle(UIColor.blueColor(), tintColor: UIColor.whiteColor())
```

Change this around to make it look however you want it to look! 

### v0.1.9
Fixed the constraints breaking in the background, no more annoying spam log messages!

## In the Pipeline
- more customization of the appearance
- the big one: better integration into projects, by making this view controller accessible to storyboards, subclassing, etc. That is in the works, and hopefully will come out soon!

