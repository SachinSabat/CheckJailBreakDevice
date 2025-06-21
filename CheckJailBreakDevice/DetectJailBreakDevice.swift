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
public protocol CheckIfDeviceIsJailbroken {
    func sendTheStatusOfJailBreak(value: Bool)
}

// Constant of FileManager path
let fm = FileManager.default

// isSimulator - Returns true if it is run on Simulator
private var isSimulator: Bool {
    #if targetEnvironment(simulator)
    return true
    #else
    return false
    #endif
}

public extension CheckIfDeviceIsJailbroken {
    // Protocol function extended for JailBreak detection
    //
    func checkForJailbrokenDevice(type: JailBreakCheckAPITypes) {
        // If it is run on simulator follow the regular flow of the app
        // Check if Cydia app is installed on the device
        if !isSimulator{
            switch type {
            case .all:
                let checkStatus = canEditSandboxFilesForJailBreakDetection() || systemForkCall() || FridaDetection().isFridaDetected
                self.sendTheStatusOfJailBreak(value: checkStatus)
                return
            case .readAndWriteFiles:
                let checkStatus = canEditSandboxFilesForJailBreakDetection()
                self.sendTheStatusOfJailBreak(value: checkStatus)
                return
            case .fridaFileDetection:
                let checkStatus = FridaDetection().isFridaDetected
                self.sendTheStatusOfJailBreak(value: checkStatus)
                return
            case .systemCalls:
                let checkStatus = systemForkCall()
                self.sendTheStatusOfJailBreak(value: checkStatus)
                return
            case .checkForCydiaAppInstallation:
                guard let cydiaURL = URL(string: "cydia://"),
                      UIApplication.shared.canOpenURL(cydiaURL) else {
                    self.sendTheStatusOfJailBreak(value: false)
                    return
                }
                self.sendTheStatusOfJailBreak(value: true)
                return
            }
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
        if isJailBrokenFilesPresentInTheDirectory() {
            return true
        }
        else {
            // check for dyld libs
            if let env = ProcessInfo.processInfo.environment["DYLD_INSERT_LIBRARIES"], !env.isEmpty {
                return true  // Jailbreak suspected
            }
            //check for private content
            let path = "/private"
            let fileList = try? FileManager.default.contentsOfDirectory(atPath: path)
            if fileList != nil {
                return true // Jailbroken
            }
            // try writing files into system root lib
            let jailBreakTestText = "Test for JailBreak"
            do {
                try jailBreakTestText.write(toFile:"\(jailBreakTestText).txt",
                                            atomically:true,
                                            encoding:String.Encoding.utf8)
                return true
            } catch {
                return false
            }
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
            if checkFileIfExist {
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
