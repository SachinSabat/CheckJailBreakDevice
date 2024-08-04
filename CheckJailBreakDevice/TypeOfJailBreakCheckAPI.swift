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
public enum TypeOfJailBreakCheckAPI {
    case all, readAndWriteFiles, systemCalls, suspiciousFileDetection
    mutating public func assignJailBreakCheckType(type: TypeOfJailBreakCheckAPI) {
        switch self {
        case .all:
            self = .all
        case .readAndWriteFiles:
            self = .readAndWriteFiles
        case .systemCalls:
            self = .systemCalls
        case .suspiciousFileDetection:
            self = .suspiciousFileDetection
        }
    }
}
