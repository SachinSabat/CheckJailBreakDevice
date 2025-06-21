//
//  FridaDetection.swift
//  CheckJailBreakDevice
//
//  Created by Sachin Sabat on 04/08/24.
//

import Foundation
import MachO
import Darwin

public final class FridaDetection {

    var isFridaDetected: Bool {
        get {
            if isSuspiciousLibraryLoaded() { return true }
            if isFridaEnvironmentVariablePresent() { return true }
            if isSuspiciousDynamicLibrariesPresent() { return true }
            if isRestrictedPathsAccessible() { return true }
            if isSuspiciousSymlinkPresent() { return true }
            if isSuspiciousParentProcessPresent() { return true }
            return false
        }
    }

    private func isSuspiciousLibraryLoaded() -> Bool {
        // Array of known suspicious libraries or patterns to check for
        let suspiciousLibraryPatterns = [
            "frida",        // Example: Frida related libraries
            "libinjector"   // Example: Other common library names
        ]

        // It returns the total number of dynamic libraries (images) currently loaded into the process. This count is used to iterate through the libraries.
        let libraryCount = _dyld_image_count()
            // This loop iterates over the range from 0 to libraryCount - 1, accessing each loaded library by its index.
            for index in 0..<libraryCount {
                //  It retrieves the name of the library at the specified index. Since this function returns an optional UnsafePointer<CChar>?, you use guard let to safely unwrap the optional. If the name cannot be retrieved (i.e., imageName is nil), the loop continues to the next index.
                guard let imageName = _dyld_get_image_name(index) else {
                    continue
                }
                // Convert the C string to a Swift string
                let libraryName = String(cString: imageName)

                // This nested loop iterates over each pattern in suspiciousLibraryPatterns. It converts both libraryName and pattern to lowercase to perform a case-insensitive comparison.
                for pattern in suspiciousLibraryPatterns {
                    if libraryName.lowercased().contains(pattern.lowercased()) {
                        return true
                    }
                }
            }

            return false
    }

    private func isFridaEnvironmentVariablePresent() -> Bool {
        // This array contains names of environment variables that are commonly set by Frida or related tools.
        let environmentVariables = ["FRIDA", "FRIDA_SERVER"]
        // Fetches the current environment variables of the process.
        let environment = ProcessInfo.processInfo.environment
        // Iterates over the list of environment variables you are interested in.
        for variable in environmentVariables {
            // Checks if the environment variable is set (i.e., not nil).
            if environment[variable] != nil {
                return true
            }
        }
        return false
    }
    
    private func isSuspiciousDynamicLibrariesPresent() -> Bool {
        let imageCount = _dyld_image_count()
        for i in 0..<imageCount {
            if let name = _dyld_get_image_name(i) {
                let imagePath = String(cString: name)
                if imagePath.lowercased().contains("hook") ||
                   imagePath.lowercased().contains("substrate") ||
                   imagePath.lowercased().contains("roothide") {
                    return true
                }
            }
        }
        return false
    }
    
    private func isRestrictedPathsAccessible() -> Bool {
        return fopen("/bin/bash", "r") != nil || fopen("/Applications/Cydia.app", "r") != nil
    }
    
    private func isSuspiciousSymlinkPresent() -> Bool {
        let paths = ["/Applications", "/usr/lib"]
        for path in paths {
            var statInfo = stat()
            if lstat(path, &statInfo) == 0 && (statInfo.st_mode & S_IFMT) == S_IFLNK {
                return true
            }
        }
        return false
    }
    
    private func isSuspiciousParentProcessPresent() -> Bool {
        let ppid = getppid()
        return ppid != 1 && ppid != getpid() // unusual if not launchd or self
    }
}
