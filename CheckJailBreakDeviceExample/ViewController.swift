//
//  ViewController.swift
//  CheckJailBreakDeviceExample
//
//  Created by Sachin Sabat on 17/12/20.
//

import UIKit
import CheckJailBreakDevice

class ViewController: UIViewController, CheckDeviceIsJailbroken {
    // Method to take necessary action
    func sendTheStatusOfJailBreak(value: Bool) {
        if value{
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            // exit(-1)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // What type of check one need to do either by 'readAndWriteFiles' on system or by calling API of system to check if it can run child process
        // preferable is 'readAndWriteFiles'
        checkForJailbrokenDevice(type: .all)
    }


}

