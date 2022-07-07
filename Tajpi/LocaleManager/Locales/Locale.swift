//
//  Locale.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation

protocol Locale {
    var name: String { get };
    
    func state(paused: Bool) -> String;
    func changeState(paused: Bool) -> String;
    
    func modes() -> String;
    func modeOption() -> String;
    func modeAutomaticTransformX() -> String;
    func modeAutomaticTransformH() -> String;
    
    func updateAvailable() -> String;
    func currentVersion(version: String) -> String;
    func foundABug() -> String;
    func changeLanguage() -> String;
    
    func quit() -> String;
    
    func missingPermissions() -> String;
    func fixMissingPermisions() -> String;
}
