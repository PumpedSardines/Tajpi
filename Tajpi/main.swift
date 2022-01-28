//
//  main.swift
//  tajpi
//
//  Created by Fritiof Rusck on 2022-01-25.
//

import Foundation
import SwiftUI

let app = NSApplication.shared


// startKeyboardInterception();

let delegate = AppDelegate()
app.delegate = delegate

pollCheckForUpdate();

// This function also handles stoping and starting of KeyboardInterception
pollAccessibility();


_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
