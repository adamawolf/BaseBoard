# BaseBoard

An basic implementation of the standard iOS keyboard as a keyboard extension.

## How to get started.

1. To get started, make sure you have Cocoapods installed.
2. Create your own Keyboard Extension and Wrapper app using Xcode. Follow [these instructions](https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/Keyboard.html#//apple_ref/doc/uid/TP40014214-CH16-SW7).
3. Integrate the BaseBoard pod. Link it with your Keyboard Extension target (see SampleProject's Podfile for an example).
4. In keyboard extension's KeyboardViewController.h:
  a. ```#import <BaseBoard/BaseBoard.h>```
  b. Change your KeyboardViewController to be a subclass of ```BBDKeyboardViewController```.
  c. Delete the template viewDidLoad, etc. implementations from KeyboardViewController.m.

## How to extend.



## How to contribute. 

The project uses [Objective Clean](http://objclean.com/) to enforce coding standards. Please install that app and fix all style warnings before sending a pull request.
