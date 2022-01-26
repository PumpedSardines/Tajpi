//
//  eng.swift
//  tajpi
//
//  Created by Fritiof Rusck on 2022-01-25.
//

import Foundation

class Eng: Locale {
    func optionMode() -> String {
        return "Option + key"
    }
    
    func automaticTransformMode() -> String {
        return "Transform sh and sx"
    }
    
    func mode() -> String {
        return "Modes"
    }
    
    
    static func name() -> String {
        return "English"
    }
    
    func quit() -> String {
        return "Quit"
    }
    
    func language() -> String {
        return "Language"
    }
    
    func info(_ running: Bool) -> String {
        return (running ? "Running" : "Halted")
    }
    
    func running(_ running: Bool) -> String {
        return (running ? "Stop" : "Start")
    }
}
