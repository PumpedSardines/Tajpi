//
//  Esperanto.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-28.
//

import Foundation

struct Esperanto: Locale {
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
    
    func modeAutomaticTransform() -> String {
        return "Transformu sh kaj sx";
    }
    
    func updateAvailable() -> String {
        return "Nova versio disponebla!";
    }
    
    func currentVersion(version: String) -> String {
        return "Versio: " + version;
    }
    
    func foundABug() -> String {
        return "Trovis cimon?"
    }
    
    func changeLanguage() -> String {
        return "Ŝanĝi lingvon";
    }
    
    func quit() -> String {
        return "Forlasu";
    }
    
    
    
}
