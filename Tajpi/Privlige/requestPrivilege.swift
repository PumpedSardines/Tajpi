//
//  Privlige.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation
import Cocoa

var hasPrivilege = false;

func requestPrivilege() {
    let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
    let privOptions = [trusted: true]
    let accessEnabled = AXIsProcessTrustedWithOptions(privOptions as CFDictionary)
    
    if !accessEnabled || !AXIsProcessTrusted() {
        pollAccessibility()
    }
    hasPrivilege = true;
}

private func pollAccessibility() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        if AXIsProcessTrusted() {
            print("WE HAVE")
            hasPrivilege = true;
        } else {
            pollAccessibility()
        }
    }
}
