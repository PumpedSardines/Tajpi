//
//  Privlige.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation
import Cocoa
import CoreGraphics
import Dispatch

var hasPrivilege = false;

func pollAccessibility() {
    let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
    let privOptions = [trusted: true]
    let accessEnabled = AXIsProcessTrustedWithOptions(privOptions as CFDictionary)
    
    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { (t) in
        let hasPrivilegeNew = AXIsProcessTrusted();

        
        if hasPrivilegeNew && !hasPrivilege {
            hasPrivilege = true;
            let worked = startKeyboardInterception();
 
            delegate.rerender();
        }
        
        if (!hasPrivilegeNew && hasPrivilege) {
            hasPrivilege = false;
            stopKeyboardInterception();
            delegate.rerender();
        }
        
        hasPrivilege = hasPrivilegeNew;
    }
}
