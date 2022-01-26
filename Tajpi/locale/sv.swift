//
//  sv.swift
//  tajpi
//
//  Created by Fritiof Rusck on 2022-01-25.
//

import Foundation

class Sv: Locale {
    func optionMode() -> String {
        return "Option + knapp"
    }
    
    func automaticTransformMode() -> String {
        return "Förvandla sh och sx"
    }
    
    func mode() -> String {
        return "Lägen"
    }
    
    static func name() -> String {
        return "Svenska"
    }
    
    func quit() -> String {
        return "Stäng av"
    }
    
    func language() -> String {
        return "Språk"
    }
    
    func info(_ running: Bool) -> String {
        return (running ? "Körs" : "Stoppad")
    }
    
    func running(_ running: Bool) -> String {
        return (running ? "Stoppa" : "Starta")
    }
}
