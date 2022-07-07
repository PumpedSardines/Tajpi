//
//  English.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation

struct English: Locale {
    func missingPermissions() -> String {
        return "Tajpi can't run due to lacking permissions";
    }
    
    func fixMissingPermisions() -> String {
        return "Instructions for fixing permissions";
    }
    
    var name: String = "English";
    
    func state(paused: Bool) -> String {
        return paused ? "Paused" : "Running";
    }
    
    func changeState(paused: Bool) -> String {
        return paused ? "Start" : "Pause";
    }
    
    func modes() -> String {
        return "Modes";
    }
    
    func modeOption() -> String {
        return "option + key";
    }
    
    func modeAutomaticTransformX() -> String {
        return "Transform sx";
    }
    
    func modeAutomaticTransformH() -> String {
        return "Transform sh";
    }
    
    func updateAvailable() -> String {
        return "New update available!";
    }
    
    func currentVersion(version: String) -> String {
        return "Version: " + version;
    }
    
    func foundABug() -> String {
        return "Found a bug?"
    }
    
    func changeLanguage() -> String {
        return "Change language";
    }
    
    func quit() -> String {
        return "Quit";
    }
    
}
