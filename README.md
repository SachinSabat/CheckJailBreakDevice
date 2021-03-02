# CheckJailBreakDevice
Detect Jail break device| iOS| Avoid Attackers to intrude in your application by all means possible in a single page| Supported to Swift (world first Protocol Oriented Language 🤘)

[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)  
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)

CheckJailBreakDevice is a framework with a lot of access to detect if the iOS device is a Jail Break in your iOS App.

## Features

- [x] Protocol Oriented based Implementation
- [x] Light Weigth code

## Requirements

- iOS 10.0+
- Xcode 10.0+
- Swift 5.0+

## Instructions
Download the file DetectJailBreakDevice.swift and add it into your project.

## Usage example
```swift
// Step 1:- Include Delegate "Check_Method_Of_JailBreak" in your particular ViewController/ AppDelegate.
class ViewController: UIViewController, Check_Method_Of_JailBreak {
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
        // What type of check on need to do either by 'readAndWriteFiles' on system or by calling API of system to check if it can run child process
        // preferable is 'readAndWriteFiles'
        assignJailBreakCheckType(type: .readAndWriteFiles)
     }
}
```

## Tutorial
[Medium](https://sabatsachin.medium.com/detect-jailbreak-device-in-swift-5-ios-programatically-da467028242d)

## Contribute

We would love you for the contribution to **CheckJailBreakDevice**, check the ``LICENSE`` file for more info.

## Meta

Sachin Sabat – [LinkedIn](https://www.linkedin.com/in/sachin-sabat-b9481831/) – sabat.sachin33@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[GitHub](https://github.com/SachinSabat)

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
