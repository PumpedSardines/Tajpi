//
//  LocaleManager.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-26.
//

import Foundation
import SwiftUI

class LocaleManager {
    
    static var locale: Locale = Eo();
    static var onChangeFuncs: [() -> Void] = []
    static let localeKey = "com.fritiofrusck.tajpi.locale"
    
    static func `init`() {
        let defaults = UserDefaults.standard
        if let language = defaults.string(forKey: LocaleManager.localeKey) {
            switch(language) {
            case "Sv":
                updateLocale(locale: Sv())
            case "Eng":
                updateLocale(locale: Eng())
            case "Eo":
                updateLocale(locale: Eo())
            default:
                updateLocale(locale: Eo())
            }
        }
    }
    
    private static func runOnChange() {
        for onChangeFunc in onChangeFuncs {
            onChangeFunc();
        }
    }
    
    static func onChange(completion: @escaping () -> Void) {
        onChangeFuncs.append(completion)
    }
    
    static func updateLocale(locale: Locale) {
        LocaleManager.locale = locale;
        
        let defaults = UserDefaults.standard
        switch(LocaleManager.locale) {
        case is Sv:
            defaults.set("Sv", forKey: LocaleManager.localeKey);
        case is Eng:
            defaults.set("Eng", forKey: LocaleManager.localeKey);
        case is Eo:
            defaults.set("Eo", forKey: LocaleManager.localeKey);
        default:
            exit(1);
        }
        
        runOnChange()
    }
}
