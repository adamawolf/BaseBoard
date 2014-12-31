# BaseBoard

An basic implementation of the standard iOS keyboard as a keyboard extension.

## Motivation.

As maker of [TapTyping](http://itunes.apple.com/us/app/taptyping/id364237969?mt=8), I’ve been able to track perfomrance data for 3rd party keyboards since their public release in September. It seems keyboards that rely on direct individual taps and our pre-existing "QWERTY" muscle memories constistently beat out input methods that rely heavily on swiping or auto-correct. So far, when compared with Apple's keyboard, no third party keyboard holds a candle in terms of typing speed or accuracy.

BaseBoard is a starting point so that people who would like to innovate with fundamentals-based virtual keyboarding are not forced to re-invent the wheel. Virtual keyboarding is here to stay. Let's make it better.

## How to get started.

1. Have Cocoapods installed.
2. Create your own keyboard extension and wrapper app using Xcode. Follow [Apple's instructions](https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/Keyboard.html#//apple_ref/doc/uid/TP40014214-CH16-SW7).
3. Integrate the BaseBoard pod. Link it with your keyboard extension target. [SampleProject's Podfile](https://github.com/adamawolf/BaseBoard/blob/master/SampleProject/Podfile) is an example, though make sure to use ```pod 'BaseBoard'``` for the import. Once your Podfile is set up run ```pod install``` and switch to using the generated .xcworkspace.
4. In your keyboard extension's KeyboardViewController.h:
  1. ```#import <BaseBoard/BaseBoard.h>```
  2. Change your KeyboardViewController to be a subclass of ```BBDKeyboardViewController```.
  3. Delete all of the Xcode template's method implementations from KeyboardViewController.m.

At this point you should be able to install and run the keyboard wrapper and extension on your simmulator or, with some bundle identifier modifications, on your test devices.

## How to extend.

BBDKeyboardViewController's implementation of viewDidLoad is where it sets up its Key Position Controller and its Typing Logic Controller. For your own keyboard, you'll likely want to subclass or write your own version of one or both of these components. Override viewDidLoad in your extension's KeyboardViewController and substitue in your own components.

The Key Controller defines all the key codes and corresponding attributes. To create a keyboard define your own key code eunumeration and sublcass/override elsewhere as needed.

## How to contribute. 

TODOs:

* Autocorrect.
* De-couple touch detection from UIButton's bounds. I.e. a "touch plane" that can dynamically adjust touch targets of keys depending on previously typed characters, etc.
* Refactor to enhance extendability.

BaseBoard uses [Objective Clean](http://objclean.com/) to enforce a conistent syntax. Please install that app and fix all style warnings before sending a pull request.
