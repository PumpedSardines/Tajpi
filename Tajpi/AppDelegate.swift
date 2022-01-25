//
//  AppDelegate.swift
//  tajpi
//
//  Created by Fritiof Rusck on 2022-01-25.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!
    var locale: Locale = Eo()
    var globalObserver: Any!
    var localObserver: Any!
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        KeyboardRoutine.Init();
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.title = "Tajpi"
        }
        
        setupMenus()
        
        
    }
    
    @objc func onMenuRunningClick() {
        // Invert if it's running or not
        KeyboardRoutine.paused = !KeyboardRoutine.paused
        setupMenus()
    }
    
    func setupMenus() {
        // Create the menu
        let menu = NSMenu()
        menu.autoenablesItems = false // This i needed for isEnabled to work
        
        // Create a info text that diplays current status
        let info = NSMenuItem(title: locale.info(!KeyboardRoutine.paused), action: #selector(onMenuRunningClick) , keyEquivalent: "")
        info.isEnabled = false
        menu.addItem(info)
        
        menu.addItem(NSMenuItem.separator())
        
        // Create a button to enable or disable execution
        let runningButton = NSMenuItem(title: locale.running(!KeyboardRoutine.paused), action: #selector(onMenuRunningClick) , keyEquivalent: "")
        menu.addItem(runningButton)
        
        let languageButton = NSMenuItem(title: locale.language(), action: nil, keyEquivalent: "")
        menu.addItem(languageButton)
        menu.setSubmenu(getLanguageMenu(), for: languageButton)
        

        
        menu.addItem(NSMenuItem.separator())
        
        // Add a quit button
        menu.addItem(NSMenuItem(title: locale.quit(), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        
        statusItem.menu = menu
    }
    
    @objc func setLanguageEng() {
        locale = Eng();
        setupMenus()
    }
    
    @objc func setLanguageEo() {
        locale = Eo();
        setupMenus()
    }
    
    @objc func setLanguageSv() {
        locale = Sv();
        setupMenus()
    }
    
    func getLanguageMenu() -> NSMenu {
        let menu = NSMenu();
        
        // Init eng button
        let eng = NSMenuItem(title: Eng.name(), action: #selector(setLanguageEng) , keyEquivalent: "")
        eng.state = .off
        if(locale is Eng) {
            eng.state = .on
        }
        
        // Init eo button
        let eo = NSMenuItem(title: Eo.name(), action: #selector(setLanguageEo) , keyEquivalent: "")
        eo.state = .off
        if(locale is Eo) {
            eo.state = .on
        }
        
        // Init eng button
        let sv = NSMenuItem(title: Sv.name(), action: #selector(setLanguageSv) , keyEquivalent: "")
        sv.state = .off
        if(locale is Sv) {
            sv.state = .on
        }
        
        menu.addItem(eo);
        menu.addItem(eng);
        menu.addItem(sv);
        
        return menu
    }
}
