//
//  DetectJailBreakDevice.swift
//  CheckJailBreakDevice
//
//  Created by Sachin Sabat on 17/12/20.
//

import Foundation
import UIKit

// Protocol function
//
// sendTheStatusOfJailBreak:- True/ False value to be send if device is JailBreak
//
public protocol CheckDeviceIsJailbroken {
    func sendTheStatusOfJailBreak(value: Bool)
}

// Constant of FileManager path
let fm = FileManager.default

// isSimulator - Returns true if it is run on Simulator
private var isSimulator: Bool {
    return TARGET_OS_SIMULATOR != 0
}

public extension CheckDeviceIsJailbroken {
    // Protocol function extended for JailBreak detection
    //
    func checkForJailbrokenDevice(type: TypeOfJailBreakCheckAPI) {
        // If it is run on simulator follow the regular flow of the app
        if !isSimulator{
            // Check if Cydia app is installed on the device
            guard let cydiaURL = URL(string: "cydia://"),
                  UIApplication.shared.canOpenURL(cydiaURL) else {
                switch type {
                case .all:
                    let checkStatus = canEditSandboxFilesForJailBreakDetection() || systemForkCall() || FridaDetection().isFridaDetected
                    self.sendTheStatusOfJailBreak(value: checkStatus)
                    return
                case .readAndWriteFiles:
                    let checkStatus = canEditSandboxFilesForJailBreakDetection()
                    self.sendTheStatusOfJailBreak(value: checkStatus)
                    return
                case .suspiciousFileDetection:
                    let checkStatus = FridaDetection().isFridaDetected
                    self.sendTheStatusOfJailBreak(value: checkStatus)
                    return
                case .systemCalls:
                    let checkStatus = systemForkCall()
                    self.sendTheStatusOfJailBreak(value: checkStatus)
                    return
                }
            }
            self.sendTheStatusOfJailBreak(value: true)
        }
        self.sendTheStatusOfJailBreak(value: false)
    }
    
    // func - canEditSandboxFilesForJailBreakDetecttion
    //
    // It tries to write into system files
    // If it is able to write files then it is JailBroken device
    // Else checks files in the root directory from the filesPathToCheck array
    //
    func canEditSandboxFilesForJailBreakDetection() -> Bool {
        let jailBreakTestText = "Test for JailBreak"
        do {
            try jailBreakTestText.write(toFile:"/private/jailBreakTestText.txt", atomically:true, encoding:String.Encoding.utf8)
            return true
        } catch {
            let resultJailBroken = isJailBrokenFilesPresentInTheDirectory()
            return resultJailBroken
        }
    }
    
    // func - isJailBrokenFilesPresentInTheDirectory
    //
    // It checks from the array 'filesPathToCheck' that particular file or app
    // are installed on the device
    // If file exist then it is jail broken
    //
    func isJailBrokenFilesPresentInTheDirectory() -> Bool{
        var checkFileIfExist: Bool = false
        FilesPathToCheck().filesPathToCheck.forEach {
            checkFileIfExist =  fm.fileExists(atPath: $0) ? true : false
            if checkFileIfExist{
                return
            }
        }
        
        return checkFileIfExist
    }
    
    // func:- systemForkCall
    //
    // It is used to check if there is a child process run at kernel level
    //
    func systemForkCall() -> Bool{
        
        let pid = getpgrp()
        
        if pid < 0
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
}
