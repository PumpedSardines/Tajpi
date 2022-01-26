//
//  Keyboard.swift
//  tajpi
//
//  Created by Fritiof Rusck on 2022-01-25.
// 
//  This file handles keyboard events and will block / change depending on state
//

import Foundation
import SwiftUI
import Swift

var paused = false   // If the program should pause the letter switching
var enableOption = true;
var enableAutomaticTransform = false;
private let keyboardKey = "com.fritiofrusck.tajpi.keyboard."

func loadMode() {
    let defaults = UserDefaults.standard
    
    if let v = defaults.string(forKey: keyboardKey + "option") {
        if(v == "on") {
            enableOption = true;
        } else {
            enableOption = false;
        }
    }
    
    if let v = defaults.string(forKey: keyboardKey + "automaticTransform") {
        if(v == "on") {
            enableAutomaticTransform = true;
        } else {
            enableAutomaticTransform = false;
        }
    }
    
    if let v = defaults.string(forKey: keyboardKey + "paused") {
        if(v == "on") {
            paused = true;
        } else {
            paused = false;
        }
    }

}

func storeMode() {
    let defaults = UserDefaults.standard;
    defaults.set(option ? "on" : "off", forKey: keyboardKey + "option");
    defaults.set(enableAutomaticTransform ? "on" : "off", forKey: keyboardKey + "automaticTransform");
    defaults.set(paused ? "on" : "off", forKey: keyboardKey + "paused");
}


private var option = false   // Weather or not the option key is pressed down
private var shift = false    // Weather or not the shift key is pressed down
private var lastKey: String? = nil;

func startKeyboardProcess() {
    loadMode();
    let accessor = AccessibilityAuthorization()
    accessor.checkAccessibility {
        startListening()
    }
}

private func startListening() {
    let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
    guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                           place: .headInsertEventTap,
                                           options: .defaultTap,
                                           eventsOfInterest: CGEventMask(eventMask),
                                           callback: callback,
                                           userInfo: nil)
    else {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {startListening()}
        return;
    }
    
    let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, CFRunLoopMode.commonModes)
    CGEvent.tapEnable(tap: eventTap, enable: true)
    ()
}


private func doubleDelete(newLetter: String) {
    let sourceRef = CGEventSource(stateID: .combinedSessionState)
    
    func pressKeyUp(_ keyCode: CGKeyCode) {
        let keyUpEvent = CGEvent(keyboardEventSource: sourceRef,
                                         virtualKey: keyCode,
                                         keyDown: false)
        keyUpEvent?.post(tap: .cghidEventTap)
    }
    
    // ĥĥ
    
    func pressKeyDown(_ keyCode: CGKeyCode) {
        let keyDownEvent = CGEvent(keyboardEventSource: sourceRef,
                                           virtualKey: keyCode,
                                           keyDown: true)
        keyDownEvent?.post(tap: .cghidEventTap)
    }
    
    func pressKey(_ keyCode: CGKeyCode) {
        pressKeyDown(keyCode);pressKeyUp(keyCode);
    }
    
    pressKey(0x33);
    
    
    let utf16Chars = Array(newLetter.utf16);
    
    let keyDownEvent = CGEvent(keyboardEventSource: sourceRef,
                                       virtualKey: 0,
                                       keyDown: true)
    
    keyDownEvent?.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
    keyDownEvent?.post(tap: .cghidEventTap)
    
    let keyUpEvent = CGEvent(keyboardEventSource: sourceRef,
                                       virtualKey: 0,
                                       keyDown: false)
    
    keyUpEvent?.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
    keyUpEvent?.post(tap: .cghidEventTap)
}




private func callback(proxy : CGEventTapProxy, type : CGEventType, event : CGEvent, refcon : UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    
    func espTransform(shift: Bool, keyCode: Int64) -> String? {
        switch(keyCode) {
        case 8:
            return shift ? "Ĉ" : "ĉ"
        case 5:
            return shift ? "Ĝ" : "ĝ"
        case 4:
            return shift ? "Ĥ" : "ĥ"
        case 38:
            return shift ? "Ĵ" : "ĵ"
        case 1:
            return shift ? "Ŝ" : "ŝ"
        case 32:
            return shift ? "Ŭ" : "ŭ"
        default:
            return nil;
        }
    }
    
    // If either option or shift was pressed down
    if type == .flagsChanged {
        if let e = NSEvent(cgEvent: event) {
            let current = e.modifierFlags.intersection(.deviceIndependentFlagsMask)
            
            // Modify state
            option = false
            shift = false
            
            if current.contains(.shift) {
                shift = true
            }
            
            if current.contains(.option) {
                option = true
            }
        }
        return Unmanaged.passRetained(event)
    }
    
    // Early return if we're paused
    if paused {
        return Unmanaged.passRetained(event)
    }
    
    // Check for keypress
    if [.keyDown , .keyUp].contains(type) && enableOption {
        
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        let repeatedKey = event.getIntegerValueField(.keyboardEventAutorepeat)
        
        if let letter = espTransform(shift: shift, keyCode: keyCode), option && repeatedKey == 0 {
            let utf16Chars = Array(letter.utf16);
            event.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
            return Unmanaged.passRetained(event)
        }
    }
    
    
    let repeatedKey = event.getIntegerValueField(.keyboardEventAutorepeat) != 0;
    
    // replace sh -> ŝ
    if [.keyDown].contains(type) && !repeatedKey && lastKey != nil && enableAutomaticTransform {
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        if let key = lastKey {
            print("DOWN FIRST " + key);
        }
        
        if let last = lastKey {
            // h and x
            if [ 0x04, 0x07 ].contains(keyCode) {
                // One left than delete then one right
                doubleDelete(newLetter: last);
                lastKey = nil;
                return nil;
            }
        }
    }
    
    if type == .keyDown && !repeatedKey && enableAutomaticTransform {
        if let key = lastKey {
            print("DOWN " + key);
        }
        
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        lastKey = espTransform(shift: shift, keyCode: keyCode);
        return Unmanaged.passRetained(event)
    }
            
    return Unmanaged.passRetained(event)
}




