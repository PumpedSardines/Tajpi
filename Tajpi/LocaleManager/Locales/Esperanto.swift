//
//  Esperanto.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-28.
//

import Foundation

struct Esperanto: Locale {
    func missingPermissions() -> String {
        return "Tajpi ne povas kuri pro manko de permesoj";
    }
    
    func fixMissingPermisions() -> String {
        return "Instrukcioj por ripari permesojn";
    }
    
    var name: String = "Esperanto";
    
    func state(paused: Bool) -> String {
        return paused ? "Paŭzita" : "Kuras";
    }
    
    func changeState(paused: Bool) -> String {
        return paused ? "Komencu" : "Paŭzu";
    }
    
    func modes() -> String {
        return "Modoj";
    }
    
    func modeOption() -> String {
        return "option + klavo";
    }
    
    func modeAutomaticTransformH() -> String {
        return "Transformu sh";
    }
    
    func modeAutomaticTransformX() -> String {
        return "Transformu sx";
    }
    
    func updateAvailable() -> String {
        return "Nova versio disponebla!";
    }
    
    func currentVersion(version: String) -> String {
        return "Versio: " + version;
    }
    
    func foundABug() -> String {
        return "Ĉu vi trovis cimon?"
    }
    
    func changeLanguage() -> String {
        return "Ŝanĝu la lingvon";
    }
    
    func quit() -> String {
        return "Forlasu";
    }
    
    
    
}
