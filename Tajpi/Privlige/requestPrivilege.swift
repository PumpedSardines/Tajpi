//
//  Privlige.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation
import Cocoa

var hasPrivilege = false;

func pollAccessibility() {
    let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
    let privOptions = [trusted: true]
    let accessEnabled = AXIsProcessTrustedWithOptions(privOptions as CFDictionary)
    
    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in

        let hasPrivilegeNew = AXIsProcessTrusted();
        
        
        if hasPrivilegeNew && !hasPrivilege {
            hasPrivilege = true;
            delegate.rerender();
        }
        
        if (!hasPrivilegeNew && hasPrivilege) {
            hasPrivilege = false;
            delegate.rerender();
        }
        
        hasPrivilege = hasPrivilegeNew;
    }
}
