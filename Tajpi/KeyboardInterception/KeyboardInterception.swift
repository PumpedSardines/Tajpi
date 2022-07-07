//
//  KeyboardInterception.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation
import SwiftUI
import Swift



var paused = BoolState(id: "keyboard.pause", value: false);
var option = BoolState(id: "keyboard.option", value: true);
var automaticTransformX = BoolState(id: "keyboard.automaticTransformX", value: false);
var automaticTransformH = BoolState(id: "keyboard.automaticTransformH", value: false);

private var loop: CFRunLoop? = nil;
private var loopSource: CFRunLoopSource? = nil;
private var eventTap: CFMachPort? = nil;

func startKeyboardInterception() -> Bool {
    // This code is hard to understand, and that's because these low level api's are often very confusing
    // What this function does is starting an "event listener" which listens for keypress events
    // If it can't do that it'll start a DispatchQueue and try again 300 miliseconds later
    // Since the callback needs to be a c function, it was hard to make anything pretty out of this
    
    let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
    eventTap = CGEvent.tapCreate(
        tap: .cgSessionEventTap,
        place: .headInsertEventTap,
        options: .defaultTap,
        eventsOfInterest: CGEventMask(eventMask),
        callback: keyboardCallback,
        userInfo: nil
    )
    
    guard let port = eventTap else { return false }
    
    loopSource = CFMachPortCreateRunLoopSource(kCFAllocatorSystemDefault, port, 0)
    guard let source = loopSource else { return false }
    
    loop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(loop, source, CFRunLoopMode.commonModes)
    CFRunLoopRun()
    
    CGEvent.tapEnable(tap: port, enable: true)
    
    return true;
}

func stopKeyboardInterception() {
    if let port = eventTap {
        CGEvent.tapEnable(tap: port, enable: false)
    }
    CFRunLoopSourceInvalidate(loopSource);
    CFRunLoopStop(loop);
    CFMachPortInvalidate(eventTap)
}
