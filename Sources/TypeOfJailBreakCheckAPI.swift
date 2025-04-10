//
//  TypeOfJailBreakCheckAPI.swift
//  CheckJailBreakDevice
//
//  Created by Sachin Sabat on 04/08/24.
//

import Foundation
// enum - TypeOfJailBreakCheckAPI
//
// Developer can select which func call they want to check for jail break detection
// Either readWrite or systemCalls
// It is preferabble to call readAndWrite func
//
public enum JailBreakCheckAPITypes {
    case all, readAndWriteFiles, systemCalls, fridaFileDetection
    mutating public func assignJailBreakCheckType(type: JailBreakCheckAPITypes) {
        switch self {
        case .all:
            self = .all
        case .readAndWriteFiles:
            self = .readAndWriteFiles
        case .systemCalls:
            self = .systemCalls
        case .fridaFileDetection:
            self = .fridaFileDetection
        }
    }
}
