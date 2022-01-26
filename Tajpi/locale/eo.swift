//
//  eo.swift
//  tajpi
//
//  Created by Fritiof Rusck on 2022-01-25.
//

import Foundation

class Eo: Locale {
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
        return "Esperanto"
    }
    
    func quit() -> String {
        return "Forlasu"
    }
    
    func language() -> String {
        return "Lingvo"
    }
    
    func info(_ running: Bool) -> String {
        return (running ? "Kurantas" : "Haltita")
    }
    
    func running(_ running: Bool) -> String {
        return (running ? "Haltu" : "Komencu")
    }
}
