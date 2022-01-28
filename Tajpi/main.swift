//
//  main.swift
//  tajpi
//
//  Created by Fritiof Rusck on 2022-01-25.
//

import Foundation
import SwiftUI

let app = NSApplication.shared

pollCheckForUpdate();
pollAccessibility();
startKeyboardInterception();

let delegate = AppDelegate()
app.delegate = delegate



_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
