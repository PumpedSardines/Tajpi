//
//  keyboardCallback.swift.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation
import SwiftUI
import Swift

struct KeyboardStatus {
    static var option: Bool = false;
    static var shift: Bool = false;
    static var lastKey: String? = nil;
}

// This is the Callback function for keystrokes
func keyboardCallback(proxy : CGEventTapProxy, type : CGEventType, event : CGEvent, refcon : UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    
    // If either option or shift was pressed down
    if type == .flagsChanged {
        if let e = NSEvent(cgEvent: event) {
            let current = e.modifierFlags.intersection(.deviceIndependentFlagsMask)
            KeyboardStatus.option = current.contains(.option);
            KeyboardStatus.shift = current.contains(.shift);
        }
        return Unmanaged.passRetained(event)
    }
    
    // Early return if we're paused
    if paused.value {
        return Unmanaged.passRetained(event)
    }
    
    // Check for keypress
    if [.keyDown , .keyUp].contains(type) && option.value {
        
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        let repeatedKey = event.getIntegerValueField(.keyboardEventAutorepeat)
        
        if let letter = espTransform(shift: KeyboardStatus.shift, keyCode: keyCode), KeyboardStatus.option && repeatedKey == 0 {
            let utf16Chars = Array(letter.utf16);
            event.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
            return Unmanaged.passRetained(event)
        }
    }
    
    
    let repeatedKey = event.getIntegerValueField(.keyboardEventAutorepeat) != 0;
    // replace sh -> ŝ
    if [.keyDown].contains(type) && !repeatedKey && KeyboardStatus.lastKey != nil && automaticTransform.value {
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        
        if let last = KeyboardStatus.lastKey {
            // h and x
            if [ 0x04, 0x07 ].contains(keyCode) {
                // One left than delete then one right
                replaceCombination(newLetter: last);
                KeyboardStatus.lastKey = nil;
                return nil;
            }
        }
    }
    
    if type == .keyDown && !repeatedKey && automaticTransform.value {
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        KeyboardStatus.lastKey = espTransform(shift: KeyboardStatus.shift, keyCode: keyCode);
        return Unmanaged.passRetained(event)
    }
    
    return Unmanaged.passRetained(event)
}

private func espTransform(shift: Bool, keyCode: Int64) -> String? {
    switch(keyCode) {
    case KeyCodes.c:
        return shift ? "Ĉ" : "ĉ"
    case KeyCodes.g:
        return shift ? "Ĝ" : "ĝ"
    case KeyCodes.h:
        return shift ? "Ĥ" : "ĥ"
    case KeyCodes.j:
        return shift ? "Ĵ" : "ĵ"
    case KeyCodes.s:
        return shift ? "Ŝ" : "ŝ"
    case KeyCodes.u:
        return shift ? "Ŭ" : "ŭ"
    default:
        return nil;
    }
}
