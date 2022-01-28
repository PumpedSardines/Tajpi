//
//  replaceCombination.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation
import SwiftUI
import Swift

func replaceCombination(newLetter: String) {
    let sourceRef = CGEventSource(stateID: .combinedSessionState)
    
    func pressKeyUp(_ keyCode: CGKeyCode) {
        let keyUpEvent = CGEvent(keyboardEventSource: sourceRef,
                                 virtualKey: keyCode,
                                 keyDown: false)
        keyUpEvent?.post(tap: .cghidEventTap)
    }
    
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
