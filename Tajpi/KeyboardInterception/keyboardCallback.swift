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
    
    if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
        print("DISABLE");
        //CGEvent.tapEnable(tap: eventTap!, enable: true)
        return Unmanaged.passRetained(event)
    }
    
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
    
    // MARK: - Change if option key is pressed
    
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
    
    
    // MARK: - Automatic transform sh or sx
    
    // Stores if any transform is enabled
    // Since this logic is largely shared, this cleans the code up a bit
    let isTransformEnabled = (automaticTransformX.value || automaticTransformH.value);
    
    // Is this a repeatKey aka is this holding down a key for longer.
    // This is especially a problem since hh should be transformed
    let repeatedKey = event.getIntegerValueField(.keyboardEventAutorepeat) != 0;
    
    
    // This first if checks if the current event is either a x or a h and replace the last letter if nesseccary
    // replace sh -> ŝ
    if [.keyDown].contains(type) && !repeatedKey && KeyboardStatus.lastKey != nil && isTransformEnabled {
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        
        if let last = KeyboardStatus.lastKey {
            
            // Add which keycodes should transform automatically
            var availbleKeyCodes: [Int64] = [];
            
            if(automaticTransformX.value) {
                availbleKeyCodes.append(0x07);
            }
            
            if(automaticTransformH.value) {
                availbleKeyCodes.append(0x04);
            }
            
            // Replace the last key
            if availbleKeyCodes.contains(keyCode) {
                // One left than delete then one right
                replaceCombination(newLetter: last);
                KeyboardStatus.lastKey = nil;
                return nil;
            }
        }
    }
    
    // This if stores the pressed key as "lastKey"
    if type == .keyDown && !repeatedKey && (automaticTransformX.value || automaticTransformH.value) {
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
