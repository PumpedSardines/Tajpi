//
//  main.swift
//  tajpi
//
//  Created by Fritiof Rusck on 2022-01-25.
//

// entrypoint for application
// copy pasted

import Foundation
import SwiftUI

let app = NSApplication.shared

LocaleManager.`init`()
//startKeyboardProcess();

let delegate = AppDelegate()
app.delegate = delegate
newVersion();

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)

