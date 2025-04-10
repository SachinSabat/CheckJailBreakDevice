//
//  FilesPathToCheck.swift
//  CheckJailBreakDevice
//
//  Updated on 10/04/25.
//

import Foundation

public struct FilesPathToCheck {
    // Array - filesPathToCheck
    //
    // Important files and App to check if the device is jailBroken
    //
    var filesPathToCheck: [String] {

        var paths: [String] = [
            "/.bootstrapped_electra", // Electra jailbreak indicator
            "/.cydia_no_stash", // unc0ver jailbreak indicator
            "/.installed_unc0ver", // unc0ver jailbreak file
            "/Applications/Cydia.app", // Cydia jailbreak app
            "/Applications/FakeCarrier.app", // Jailbreak tweak - fake carrier
            "/Applications/FlyJB.app", // FlyJB jailbreak-related app
            "/Applications/Icy.app", // Alternative jailbreak app store
            "/Applications/IntelliScreen.app", // Jailbreak tweak
            "/Applications/MxTube.app", // Jailbreak app for downloading YouTube videos
            "/Applications/RockApp.app", // Rock Your Phone jailbreak store
            "/Applications/SBSetttings.app", // Misspelled SBSettings (possible typo)
            "/Applications/SBSettings.app", // Popular jailbreak tweak for system toggles
            "/Applications/Sileo.app", // Sileo jailbreak package manager
            "/Applications/Snoop-itConfig.app", // Security testing/jailbreak related tool
            "/Applications/WinterBoard.app", // Theming engine for jailbroken devices
            "/Library/BawAppie/ABypass", // ABypass tweak directory
            "/Library/MobileSubstrate/CydiaSubstrate.dylib", // Cydia Substrate library
            "/Library/MobileSubstrate/DynamicLibraries", // General directory for jailbreak tweak .dylib and .plist
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist", // Tweak config file
            "/Library/MobileSubstrate/DynamicLibraries/PreferenceLoader.dylib", // PreferenceLoader tweak binary
            "/Library/MobileSubstrate/DynamicLibraries/PreferenceLoader.plist", // PreferenceLoader configuration
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist", // Veency tweak config (VNC server)
            "/Library/MobileSubstrate/MobileSubstrate.dylib", // MobileSubstrate core dynamic lib
            "/Library/PreferenceBundles/ABypassPrefs.bundle", // ABypass tweak preference pane
            "/Library/PreferenceBundles/Cephei.bundle", // Cephei tweak support lib
            "/Library/PreferenceBundles/FlyJBPrefs.bundle", // FlyJB tweak preference pane
            "/Library/PreferenceBundles/LibertyPref.bundle", // Liberty tweak preference pane
            "/Library/PreferenceBundles/ShadowPreferences.bundle", // Shadow jailbreak detection bypass
            "/Library/PreferenceBundles/SubstitutePrefs.bundle", // Substitute tweak preference pane
            "/Library/PreferenceBundles/libhbangprefs.bundle", // Preference support for tweaks
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist", // Possibly malicious daemon
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist", // Cydia startup daemon
            "/bin.sh", // Alternative shell (suspicious)
            "/bin/bash", // Shell (used in many jailbreak payloads)
            "/etc/apt", // APT package system (used by jailbroken devices)
            "/etc/apt/sources.list.d/electra.list", // Electra source list
            "/etc/apt/sources.list.d/sileo.sources", // Sileo source list
            "/etc/apt/undecimus/undecimus.list", // unc0ver source list
            "/jb/amfid_payload.dylib", // unc0ver injected payload
            "/jb/jailbreakd.plist", // unc0ver jailbreak daemon config
            "/jb/libjailbreak.dylib", // unc0ver library
            "/jb/lzma", // Electra or unc0ver tool
            "/jb/offsets.plist", // unc0ver config
            "/private/var/Users/", // May be used by some jailbreaks
            "/private/var/cache/apt/", // APT package cache (jailbreak-related)
            "/private/var/lib/apt", // APT data directory
            "/private/var/lib/cydia", // Cydia data directory
            "/private/var/log/syslog", // System log (may be accessed by tweaks)
            "/private/var/mobile/Library/SBSettings/Themes", // SBSettings themes directory
            "/private/var/stash", // Classic jailbreak stash location
            "/private/var/tmp/cydia.log", // Cydia log file
            "/usr/bin/cycript", // Cycript tool used for runtime inspection
            "/usr/bin/ssh", // SSH client (not default on iOS)
            "/usr/lib/ABDYLD.dylib", // ABypass dynamic library
            "/usr/lib/ABSubLoader.dylib", // ABypass support lib
            "/usr/lib/TweakInject", // Directory for tweak injection
            "/usr/lib/libcycript.dylib", // Cycript library
            "/usr/lib/libfrida-gadget.dylib", // Frida tool for dynamic instrumentation
            "/usr/lib/libhooker.dylib", // Hooker library used in tweak development
            "/usr/lib/libjailbreak.dylib", // Jailbreak shared lib (Electra or unc0ver)
            "/usr/lib/libsubstitute.dylib", // Substitute (tweak injection lib)
            "/usr/lib/substrate", // Cydia Substrate support
            "/usr/libexec/cydia/", // Cydia executables
            "/usr/libexec/cydia/firmware.sh", // Cydia firmware script
            "/usr/libexec/sftp-server", // SFTP server (may be installed post-jailbreak)
            "/usr/libexec/ssh-keysign", // SSH helper
            "/usr/local/bin/cycript", // Cycript alternate install
            "/usr/local/lib/libfrida-gadget.dylib", // Frida alternate install path
            "/usr/sbin/frida-server", // Frida dynamic instrumentation server
            "/usr/sbin/sshd", // SSH daemon
            "/var/binpack", // checkra1n environment
            "/var/binpack/Applications/loader.app", // checkra1n loader app
            "/var/checkra1n.dmg", // checkra1n disk image
            "/var/lib/cydia", // Cydia data directory
            "/var/lib/dpkg/info/mobilesubstrate.md5sums", // MobileSubstrate file integrity
            "/var/log/apt", // APT logs
            "/var/mobile/Library/Preferences/ABPattern", // ABypass configuration
            "/var/mobile/Library/Preferences/me.jjolano.shadow.plist" // Shadow jailbreak detection bypass
        ]
        
        // These files can give false positive in the emulator
        if !isSimulator {
          paths += [
            "/bin/bash",
            "/usr/sbin/sshd",
            "/usr/libexec/ssh-keysign",
            "/bin/sh",
            "/etc/ssh/sshd_config",
            "/usr/libexec/sftp-server",
            "/usr/bin/ssh"
          ]
        }

        return paths
    }
}
