# CheckJailBreakDevice - jailbreak-detection
Detect Jail break device| iOS| Avoid Attackers to intrude in your application by all means possible in a single page| Supported to Swift (world first Protocol Oriented Language 🤘)

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)  
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)

CheckJailBreakDevice is a framework with a lot of access to detect if the iOS device is a Jail Break in your iOS App.

## Features

- [x] Protocol Oriented based Implementation
- [x] Light Weight code

## Requirements

- iOS 14.0+
- Xcode 15.0+
- Swift 5.0+

## Installation
#### Swift Package Manager
1. Open your Xcode project.
2. Go to File -> Swift Packages -> Add Package Dependency...
3. Search for CheckJailBreakDevice or Enter the repository URL: https://cocoapods.org/pods/CheckJailBreakDevice.git
4. Choose the version rule according to your preference.
5. Choose the target where you want to integrate CheckJailBreakDevice.
6. Click Finish.

#### CocoaPods
You can use [CocoaPods](https://cocoapods.org/pods/CheckJailBreakDevice) to install `CheckJailBreakDevice` by adding it to your `Podfile`:

```ruby
platform :ios, '14.0'
use_frameworks!
pod 'CheckJailBreakDevice'
```

## Usage example
```swift
// Step 1:- Include Delegate "CheckDeviceIsJailbroken" in your particular ViewController/ AppDelegate.
class ViewController: UIViewController, CheckIfDeviceIsJailbroken {
// Delegate Method to take necessary action
    func sendTheStatusOfJailBreak(value: Bool) {
        if value{
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            // exit(-1)
        }
    }
   override func viewDidLoad() {
        super.viewDidLoad()
        // Step 2:-
        // What type of check one need to do either by 'readAndWriteFiles' on system or by calling API of system to check if it can run child process
        // preferable is 'readAndWriteFiles'
            checkForJailbrokenDevice(type: .readAndWriteFiles)
     }
}
```
Also add cydia in your info.plist under LSApplicationQueriesSchemes. 
```swift
    <key>LSApplicationQueriesSchemes</key>
    <array>
    <string>cydia</string>
    </array>
```

## Tutorial
[Medium](https://sabatsachin.medium.com/detect-jailbreak-device-in-swift-5-ios-programatically-da467028242d)

## Contribute

We would love you for the contribution to **CheckJailBreakDevice**, check the ``LICENSE`` file for more info.

## Meta

Sachin Sabat – [LinkedIn](https://www.linkedin.com/in/sachin-sabat-b9481831/) – sabat.sachin33@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[GitHub](https://github.com/SachinSabat)

[swift-image]:https://img.shields.io/badge/swift-5.10-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
