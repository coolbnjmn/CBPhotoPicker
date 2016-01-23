# CBPhotoPicker
A customizable photo picker view controller for iOS -- Swift

![alt tag](https://github.com/coolbnjmn/CBPhotoPicker/blob/master/CBPhotoPickerDemo.gif)

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

### v0.1.10
Made some variables public to be visible to use the photo picker in storyboards. 

### v0.1.11
Made a lot of changes:
- completely revamped how I use touch gestures, made it a scroll view instead of my gesture recognizers...this simplifies the logic greatly
- no more rotation of images, I will bring back quarter turns as a future feature
- had to bring the overlay view up a level from the image view, so that it can be seen over it.
- fixed all snapping and zooming snap 

### v0.1.12
- Fixed the weird snapping behavior when tapping on a new photo after having zoomed on the first photo
- Added support for hiding the grid overlay -- this is done through an optional parameter in the custom style
- More bug fixes

### v0.1.13
- Fixed image centering and showing black areas -- that never happens now!
- Re-fixed the cropping at the end, since I had switched to using a scroll view I had broken it. 
- More bug fixes

### v0.1.14
- Fixed tiny bug, should resolve a possible crash in a user's code.

### v0.1.15
- Added DZNEmptyDataSet as an imported framework, so as to have better no data scenarios for users. 

### v0.1.16-0.1.19
- Fixing pod spec issues

### v0.1.20
UPDATE FROM 0.14 to THIS VERSION. 0.15-0.19 are junk, and do not work because of a failed importing of DZNEmptyDataSet
v0.1.21 will include an empty state of my own creation. 

### v0.1.21
- Finally got empty states working. Now when you have no pictures in your library, a camera prompt will be shown which will allow you to take a picture. 

### v0.1.22
- Added a public flag that tells you if the user has already selected an image or not

### v0.1.23
- Fixed an empty state issue where the empty state would be overlayed on top of photos in certain cases

### v0.1.24-v0.1.28
- No changes, all changes were reverted
## In the Pipeline
- add rotation back in
- add more customization
- better grid layout helper
- snap up and down the image preview part with the bottom collection view so that it can take full screen
