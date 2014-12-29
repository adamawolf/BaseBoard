# BaseBoard

An basic implementation of the standard iOS keyboard as a keyboard extension.

## Motivation.

Virtual keyboarding is here to stay.  As maker of [TapTyping](http://itunes.apple.com/us/app/taptyping/id364237969?mt=8) I'm in a unique position to notice a depressing trend with all of the 3rd party keyboards so far: they all suck. From the data I've gathered, absolutely none of them seem to offer any speed or accuracy advantages over Apple's stock virtual keyboard. Let's fix that.

The problem is that Apple's Keyboard Extension template in Xcode is woefully bare. BaseBoard is a starting point so that people who would like to innovate with virtual keyboarding are not forced to re-invent the wheel.

## How to get started.

1. To get started, make sure you have Cocoapods installed.
2. Create your own keyboard extension and wrapper app using Xcode. Follow [Apple's instructions](https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/Keyboard.html#//apple_ref/doc/uid/TP40014214-CH16-SW7).
3. Integrate the BaseBoard pod. Link it with your keyboard extension target. See [SampleProject's Podfile](https://github.com/adamawolf/BaseBoard/blob/master/SampleProject/Podfile) for an example.
4. In your keyboard extension's KeyboardViewController.h:
  1. ```#import <BaseBoard/BaseBoard.h>``` (or put this in your .pch to import globally)
  2. Change your KeyboardViewController to be a subclass of ```BBDKeyboardViewController```.
  3. Delete the Xcode template's method implementations from KeyboardViewController.m.

At this point you should be able to install and run the keyboard wrapper and extension on your simmulator or, with some bundle identifier modifications, on your test devices.

## How to extend.

BBDKeyboardViewController's implementation of viewDidLoad is where it sets up its Key Position Controller and its Typing Logic Controller. For your own keyboard, you'll likely want to subclass or write your own version of one or both of these components. Override viewDidLoad in your extension's KeyboardViewController and substitue in your own components.

The Key Controller defines all the key codes and corresponding attributes. To create a keyboard define your own key code eunumeration and sublcass/override elsewhere as needed.

## How to contribute. 

A rough todo list:

* Autocorrect.
* De-couple touch detection from UIButton's bounds. I.e. a "touch plane" class that dynamically assings taps to keys.
* Enhance extendability. I'm sure as people begin to build on top of BaseBoard many things will need to change to support extension in a sane(r) maner.

The project uses [Objective Clean](http://objclean.com/) to enforce coding standards. Please install that app and fix all style warnings before sending a pull request.
