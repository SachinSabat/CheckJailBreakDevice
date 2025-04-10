//
//  DetectJailBreakDevice.swift
//  CheckJailBreakDevice
//
//  Created by Sachin Sabat on 17/12/20.
//

import Foundation
import UIKit
import Darwin // fork
import MachO // dyld
import ObjectiveC // NSObject and Selector

// Protocol function
//
// sendTheStatusOfJailBreak:- True/ False value to be send if device is JailBreak
//
public protocol CheckIfDeviceIsJailbroken {
    func sendTheStatusOfJailBreak(value: Bool)
    typealias CheckResult = (passed: Bool, failMessage: String)
}

// Constant of FileManager path
let fm = FileManager.default

// isSimulator - Returns true if it is run on Simulator
var isSimulator: Bool {
    return checkCompile() || checkRuntime()
    
    func checkRuntime() -> Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }

    func checkCompile() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}


public extension CheckIfDeviceIsJailbroken {
    // Protocol function extended for JailBreak detection
    //
    func checkForJailbrokenDevice(type: JailBreakCheckAPITypes) {
        // If it is run on simulator follow the regular flow of the app
        if !isSimulator {
            // Check if tampered app is installed on the device
            let checkResult = self.checkURLSchemes()
            if checkResult.passed {
                switch type {
                case .all:
                    // Additional runtime checks
                    let resultCanEditSandboxFiles = canEditSandboxFilesForJailBreakDetection()
                    let resultFrida = FridaDetection().isFridaDetected
                    let resultForkCall = systemForkCall()
                    let resultPackageManagerDetected = isPackageManagerDetected()
                    

                    let result1 = self.checkExistenceOfSuspiciousFiles()
                    let result2 = self.checkSuspiciousFilesCanBeOpened()
                    let result3 = self.checkRestrictedDirectoriesWriteable()
                    let result4 = self.checkFork()
                    let result5 = self.checkSymbolicLinks()
                    let result6 = self.checkDYLD()
                    let result7 = self.checkSuspiciousObjCClasses()
                    let result8 = self.checkOpenedPorts()
                    
                    // Combine all checks into one array
                    // Final jailbreak status: false if *any* check failed
                    let isJailbroken = [resultCanEditSandboxFiles, resultFrida, resultForkCall, resultPackageManagerDetected, result1.passed, result2.passed, result3.passed, result4.passed, result5.passed, result6.passed, result7.passed, result8.passed].allSatisfy { $0 }

                    // Send final status
                    self.sendTheStatusOfJailBreak(value: isJailbroken)
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
                }
            }
            else {
                print(checkResult.failMessage)
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
        } else {
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

private extension CheckIfDeviceIsJailbroken {
    // "cydia://" URL scheme has been removed. Turns out there is app in the official App Store
    // that has the cydia:// URL scheme registered, so it may cause false positive
    // "activator://" URL scheme has been removed for the same reason.
    private func checkURLSchemes() -> CheckResult {
      let urlSchemes = [
        "zbra://",
        "cydia://",
        "undecimus://",
        "sileo://",
        "filza://",
        "activator://"
      ]
      return canOpenUrlFromList(urlSchemes: urlSchemes)
    }
    
    private func canOpenUrlFromList(urlSchemes: [String]) -> CheckResult {
      for urlScheme in urlSchemes {
        if let url = URL(string: urlScheme) {
          if UIApplication.shared.canOpenURL(url) {
            return(false, "\(urlScheme) URL scheme detected")
          }
        }
      }
      return (true, "")
    }
}

private extension CheckIfDeviceIsJailbroken {
    private func checkExistenceOfSuspiciousFiles() -> CheckResult {
        let paths = FilesPathToCheck().filesPathToCheck
        for path in paths {
          if FileManager.default.fileExists(atPath: path) {
            return (false, "Suspicious file exists: \(path)")
          } else if let result = FileChecker.checkExistenceOfSuspiciousFilesViaStat(path: path) {
            return result
          } else if let result = FileChecker.checkExistenceOfSuspiciousFilesViaFOpen(
            path: path,
            mode: .readable
          ) {
            return result
          } else if let result = FileChecker.checkExistenceOfSuspiciousFilesViaAccess(
            path: path,
            mode: .readable
          ) {
            return result
          }
        }
        
        return (true, "")
    }
    
    private func checkSuspiciousFilesCanBeOpened() -> CheckResult {
      var paths = [
        "/.installed_unc0ver",
        "/.bootstrapped_electra",
        "/Applications/Cydia.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/etc/apt",
        "/var/log/apt"
      ]
      
      // These files can give false positive in the emulator
      if !isSimulator {
        paths += [
          "/bin/bash",
          "/usr/sbin/sshd",
          "/usr/bin/ssh"
        ]
      }
      
      for path in paths {
        if FileManager.default.isReadableFile(atPath: path) {
          return (false, "Suspicious file can be opened: \(path)")
        } else if let result = FileChecker.checkExistenceOfSuspiciousFilesViaFOpen(
          path: path,
          mode: .writable
        ) {
          return result
        } else if let result = FileChecker.checkExistenceOfSuspiciousFilesViaAccess(
          path: path,
          mode: .writable
        ) {
          return result
        }
      }
      
      return (true, "")
    }
    
    private func checkRestrictedDirectoriesWriteable() -> CheckResult {
      let paths = [
        "/",
        "/root/",
        "/private/",
        "/jb/"
      ]
      
      if FileChecker.checkRestrictedPathIsReadonlyViaStatvfs(path: "/") == false {
        return (false, "Restricted path '/' is not Read-Only")
      } else if FileChecker.checkRestrictedPathIsReadonlyViaStatfs(path: "/") == false {
        return (false, "Restricted path '/' is not Read-Only")
      } else if FileChecker.checkRestrictedPathIsReadonlyViaGetfsstat(name: "/") == false {
        return (false, "Restricted path '/' is not Read-Only")
      }
      
      // If library won't be able to write to any restricted directory the return(false, ...) is never reached
      // because of catch{} statement
      for path in paths {
        do {
          let pathWithSomeRandom = path + UUID().uuidString
          try "AmIJailbroken?".write(
            toFile: pathWithSomeRandom,
            atomically: true,
            encoding: String.Encoding.utf8
          )
          // clean if succesfully written
          try FileManager.default.removeItem(atPath: pathWithSomeRandom)
          return (false, "Wrote to restricted path: \(path)")
        } catch {}
      }
      
      return (true, "")
    }
    
    private func checkFork() -> CheckResult {
      let pointerToFork = UnsafeMutableRawPointer(bitPattern: -2)
      let forkPtr = dlsym(pointerToFork, "fork")
      typealias ForkType = @convention(c) () -> pid_t
      let fork = unsafeBitCast(forkPtr, to: ForkType.self)
      let forkResult = fork()
      
      if forkResult >= 0 {
        if forkResult > 0 {
          kill(forkResult, SIGTERM)
        }
        return (false, "Fork was able to create a new process (sandbox violation)")
      }
      
      return (true, "")
    }
    
    private func checkSymbolicLinks() -> CheckResult {
      let paths = [
        "/var/lib/undecimus/apt", // unc0ver
        "/Applications",
        "/Library/Ringtones",
        "/Library/Wallpaper",
        "/usr/arm-apple-darwin9",
        "/usr/include",
        "/usr/libexec",
        "/usr/share"
      ]
      
      for path in paths {
        do {
          let result = try FileManager.default.destinationOfSymbolicLink(atPath: path)
          if !result.isEmpty {
            return (false, "Non standard symbolic link detected: \(path) points to \(result)")
          }
        } catch {}
      }
      
      return (true, "")
    }
    
    private func checkDYLD() -> CheckResult {
      let suspiciousLibraries: Set<String> = [
        "systemhook.dylib", // Dopamine - hide jailbreak detection https://github.com/opa334/Dopamine/blob/dc1a1a3486bb5d74b8f2ea6ada782acdc2f34d0a/Application/Dopamine/Jailbreak/DOEnvironmentManager.m#L498
        "SubstrateLoader.dylib",
        "SSLKillSwitch2.dylib",
        "SSLKillSwitch.dylib",
        "MobileSubstrate.dylib",
        "TweakInject.dylib",
        "CydiaSubstrate",
        "cynject",
        "CustomWidgetIcons",
        "PreferenceLoader",
        "RocketBootstrap",
        "WeeLoader",
        "/.file", // HideJB (2.1.1) changes full paths of the suspicious libraries to "/.file"
        "libhooker",
        "SubstrateInserter",
        "SubstrateBootstrap",
        "ABypass",
        "FlyJB",
        "Substitute",
        "Cephei",
        "Electra",
        "AppSyncUnified-FrontBoard.dylib",
        "Shadow",
        "FridaGadget",
        "frida",
        "libcycript"
      ]
      
      for index in 0..<_dyld_image_count() {
        let imageName = String(cString: _dyld_get_image_name(index))
        
        // The fastest case insensitive contains check.
        for library in suspiciousLibraries where imageName.localizedCaseInsensitiveContains(library) {
          return (false, "Suspicious library loaded: \(imageName)")
        }
      }
      
      return (true, "")
    }
    
    private func checkSuspiciousObjCClasses() -> CheckResult {
      if let shadowRulesetClass = objc_getClass("ShadowRuleset") as? NSObject.Type {
        let selector = Selector(("internalDictionary"))
        if class_getInstanceMethod(shadowRulesetClass, selector) != nil {
          return (false, "Shadow anti-anti-jailbreak detector detected :-)")
        }
      }
      return (true, "")
    }
    
    private func checkOpenedPorts() -> CheckResult {
        func canOpenLocalConnection(port: Int) -> Bool {
            func swapBytesIfNeeded(port: in_port_t) -> in_port_t {
                let littleEndian = Int(OSHostByteOrder()) == OSLittleEndian
                return littleEndian ? _OSSwapInt16(port) : port
            }
            
            var serverAddress = sockaddr_in()
            serverAddress.sin_family = sa_family_t(AF_INET)
            serverAddress.sin_addr.s_addr = inet_addr("127.0.0.1")
            serverAddress.sin_port = swapBytesIfNeeded(port: in_port_t(port))
            let sock = socket(AF_INET, SOCK_STREAM, 0)
            
            let result = withUnsafePointer(to: &serverAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    connect(sock, $0, socklen_t(MemoryLayout<sockaddr_in>.stride))
                }
            }
            
            defer {
                close(sock)
            }
            
            if result != -1 {
                return true // Port is opened
            }
            
            return false
        }
        
        let ports = [
            27042, // default Frida
            4444, // default Needle
            22, // OpenSSH
            44 // checkra1n
        ]
        
        for port in ports where canOpenLocalConnection(port: port) {
            return (false, "Port \(port) is open")
        }
        
        return (true, "")
    }
    
    private func isRunningOnDopamineJailbreak() -> Bool {
        // Dopamine and rootless jailbreak dylibs
        let suspiciousDylibs = [
            "libsubstrate.dylib",
            "libhooker.dylib",
            "libBlackjack.dylib",
            "libSandy.dylib",
            "libkrw.dylib",
            "libellekit.dylib"  // Dopamine 2
        ]

        // Check loaded dynamic libraries
        for i in 0..<_dyld_image_count() {
            if let imageName = _dyld_get_image_name(i) {
                let lib = String(cString: imageName)
                for suspicious in suspiciousDylibs {
                    if lib.contains(suspicious) {
                        return true
                    }
                }
            }
        }

        // Dopamine-related file paths (rootless or not)
        let suspiciousPaths = [
            "/var/jb",
            "/var/binpack",
            "/usr/lib/libellekit.dylib",
            "/etc/apt/sources.list.d/ellekit.sources",
            "/etc/apt/",
            "/.bootstrapped",
            "/.file",
            "/var/mobile/.dock", // Dopamine uses hidden folders for tweaks
            "/private/preboot"   // Mount path on rootless jailbreaks like Dopamine
        ]

        for path in suspiciousPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        // Environment variable check for injected dylibs
        if let env = getenv("DYLD_INSERT_LIBRARIES") {
            let value = String(cString: env)
            if value.contains("libhooker") || value.contains("substrate") || value.contains("ellekit") {
                return true
            }
        }

        return false
    }
    
        ///Detects real-world installations of Zebra, Installer5, and Cydia
    private func isPackageManagerDetected() -> Bool {
        //Package managers like Zebra and Installer5 are GUI apps
        //Even on rootless jailbreaks (like Dopamine), they often store config/source files under
            //  /etc/apt/sources.list.d/
            //  /var/mobile/Library/
        
        let suspiciousPaths = [
            // Package Manager apps
            "/Applications/Cydia.app",
            "/Applications/Zebra.app",
            "/Applications/Installer.app",

            // Their config/source locations
            "/etc/apt/sources.list.d/zebra.sources",
            "/etc/apt/sources.list.d/installer.sources",
            "/usr/libexec/installer",
            "/var/mobile/Library/Zebra",
            "/var/mobile/Library/Installer",

            // Backup detection if they moved the apps
            "/private/var/Applications/Zebra.app",
            "/private/var/Applications/Installer.app"
        ]

        for path in suspiciousPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        return false
    }
}
