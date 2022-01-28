//
//  KeyboardInterception.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation
import SwiftUI
import Swift



var paused = BoolState(id: "keyboard.p", value: false);
var option = BoolState(id: "keyboard.option", value: true);
var automaticTransform = BoolState(id: "keyboard.automaticTransform", value: false);



func startKeyboardInterception() {
    // This code is hard to understand, and that's because these low level api's are often very confusing
    // What this function does is starting an "event listener" which listens for keypress events
    // If it can't do that it'll start a DispatchQueue and try again 300 miliseconds later
    // Since the callback needs to be a c function, it was hard to make anything pretty out of this
    
    let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
    guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                           place: .headInsertEventTap,
                                           options: .defaultTap,
                                           eventsOfInterest: CGEventMask(eventMask),
                                           callback: keyboardCallback,
                                           userInfo: nil)
    else {
        print("Didn't work, try again");
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {startKeyboardInterception()}
        return;
    }
    
    let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, CFRunLoopMode.commonModes)
    CGEvent.tapEnable(tap: eventTap, enable: true)
    ()
}
