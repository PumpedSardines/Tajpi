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

class KeyboardRoutine {
    
    static var option = false   // Weather or not the option key is pressed down
    static var shift = false    // Weather or not the shift key is pressed down
    static var paused = false   // If the program should pause the letter switching
    
    static func Init() {
        let accessor = AccessibilityAuthorization()
        accessor.checkAccessibility {
            let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
            guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                                   place: .headInsertEventTap,
                                                   options: .defaultTap,
                                                   eventsOfInterest: CGEventMask(eventMask),
                                                   callback: CGEventCallback,
                                                   userInfo: nil) else {
                    print("failed to create event tap")
                    exit(1)
            }

            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, CFRunLoopMode.commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
            CFRunLoopRun()
        }
    }
}



func CGEventCallback(proxy : CGEventTapProxy, type : CGEventType, event : CGEvent, refcon : UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    print("")
    
    // If either option or shift was pressed down
    if type == .flagsChanged {
        if let e = NSEvent(cgEvent: event) {
            let current = e.modifierFlags.intersection(.deviceIndependentFlagsMask)
            
            // Modify state
            KeyboardRoutine.option = false
            KeyboardRoutine.shift = false
            
            if current.contains(.shift) {
                KeyboardRoutine.shift = true
            }
            
            if current.contains(.option) {
                KeyboardRoutine.option = true
            }
        }
    }

    // Check for keypress
    if [.keyDown , .keyUp].contains(type) {
        var keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        if [8, 38, 32, 1, 5, 4].contains(keyCode) && KeyboardRoutine.option && !KeyboardRoutine.paused {
            var letter = ""
            let shift = KeyboardRoutine.shift
            
            switch(keyCode) {
                case 8:
                    letter = shift ? "Ĉ" : "ĉ"
                case 5:
                    letter = shift ? "Ĝ" : "ĝ"
                case 4:
                    letter = shift ? "Ĥ" : "ĥ"
                case 38:
                    letter = shift ? "Ĵ" : "ĵ"
                case 1:
                    letter = shift ? "Ŝ" : "ŝ"
                case 32:
                    letter = shift ? "Ŭ" : "ŭ"
                default:
                    exit(1)
            }
            let utf16Chars = Array(letter.utf16);
            event.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
        }
    }
    return Unmanaged.passRetained(event)
}
