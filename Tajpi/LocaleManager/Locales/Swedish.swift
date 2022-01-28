//
//  Swedish.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-28.
//

import Foundation

struct Swedish: Locale {
    func missingPermissions() -> String {
        return "Tajpi kan inte köras på grund av bristande behörigheter"
    }
    
    func fixMissingPermisions() -> String {
        return "Instruktioner för att fixa behörigheter"
    }
    
    var name: String = "Svenska";
    
    func state(paused: Bool) -> String {
        return paused ? "Pausat" : "Körs";
    }
    
    func changeState(paused: Bool) -> String {
        return paused ? "Starta" : "Pausa";
    }
    
    func modes() -> String {
        return "Lägen";
    }
    
    func modeOption() -> String {
        return "option + tangent";
    }
    
    func modeAutomaticTransform() -> String {
        return "Gör om sh and sx";
    }
    
    func updateAvailable() -> String {
        return "Ny uppdatering tillgänlig!";
    }
    
    func currentVersion(version: String) -> String {
        return "Version: " + version;
    }
    
    func foundABug() -> String {
        return "Hittat en bug?"
    }
    
    func changeLanguage() -> String {
        return "Ändra språk";
    }
    
    func quit() -> String {
        return "Avsluta";
    }
}
