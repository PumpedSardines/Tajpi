//
//  Locale.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation

class LocaleState: State {
    var value: Locale = English();
    var id: String = ""
    
    required init(id: String, value: Locale) {
        self.id = id;
        
        if let v = getLoadable() {
            self.value = v;
        } else {
            self.value = value;
        }
    }
    
    func serialize(_ val: Locale) -> String {
        switch(val) {
        case is Esperanto:
            return "eo";
        case is English:
            return "eng";
        case is Swedish:
            return "sv";
        default:
            exit(1);
        }
    }
    
    func deserialize(_ raw: String) -> Locale {
        switch(raw) {
        case "eng":
            return English();
        case "eo":
            return Esperanto();
        case "sv":
            return Swedish();
        default:
            exit(1);
        }
    }
    
    typealias T = Locale
    

}
