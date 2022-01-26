//
//  AppDelegate.swift
//  tajpi
//
//  Created by Fritiof Rusck on 2022-01-25.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!
    var globalObserver: Any!
    var localObserver: Any!
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Init Keyboard
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            let img = NSImage(named: NSImage.Name("StatusIcon"))!
            img.size = NSMakeSize(18.0, 18.0)
            button.image = img
        }
        
        setupMenus()
        
        // If the language is changed, update the menu
        LocaleManager.onChange {
            self.setupMenus()
        }
        
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // I'm not very experienced with apples apis
        // Without this exit(0), Tajpi would only lauch after clicking the icon twice
        // Weird...
        exit(0)
    }
    
    @objc func onMenuRunningClick() {
        // Invert if it's running or not
        paused = !paused
        storeMode()
        setupMenus()
    }
    
    func setupMenus() {
        // Create the menu
        let menu = NSMenu()
        menu.autoenablesItems = false // This i needed for isEnabled to work
        let localeMenu = getLocaleMenu();
        let modeMenu = getModeMenu();
        let locale = LocaleManager.locale
        
        // Create a info text that diplays current status
        let info = NSMenuItem(title: locale.info(!paused), action: nil, keyEquivalent: "")
        info.isEnabled = false
        menu.addItem(info)
        
        menu.addItem(NSMenuItem.separator())
        
        // Create a button to enable or disable execution
        let runningButton = NSMenuItem(title: locale.running(!paused), action: #selector(onMenuRunningClick), keyEquivalent: "")
        menu.addItem(runningButton)
        
        let languageButton = NSMenuItem(title: locale.language(), action: nil, keyEquivalent: "")
        menu.addItem(languageButton)
        menu.setSubmenu(localeMenu, for: languageButton)
        
        let modeButton = NSMenuItem(title: locale.mode(), action: nil, keyEquivalent: "")
        menu.addItem(modeButton)
        menu.setSubmenu(modeMenu, for: modeButton)

        
        menu.addItem(NSMenuItem.separator())
        
        // Add a quit button
        menu.addItem(NSMenuItem(title: locale.quit(), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        
        statusItem.menu = menu
    }
    
    @objc func setLanguageEng() {
        LocaleManager.updateLocale(locale: Eng())
    }
    
    @objc func setLanguageEo() {
        LocaleManager.updateLocale(locale: Eo())
    }
    
    @objc func setLanguageSv() {
        LocaleManager.updateLocale(locale: Sv())
    }
    
    func getLocaleMenu() -> NSMenu {
        let menu = NSMenu();
        menu.autoenablesItems = true
        
        
        // Init eng button
        let eng = NSMenuItem(title: Eng.name(), action: #selector(setLanguageEng) , keyEquivalent: "")
        eng.isEnabled = true;
        eng.state = .off
        if(LocaleManager.locale is Eng) {
            eng.state = .on
        }
        
        // Init eo button
        let eo = NSMenuItem(title: Eo.name(), action: #selector(setLanguageEo) , keyEquivalent: "")
        eo.state = .off
        if(LocaleManager.locale is Eo) {
            eo.state = .on
        }
        
        // Init eng button
        let sv = NSMenuItem(title: Sv.name(), action: #selector(setLanguageSv) , keyEquivalent: "")
        sv.state = .off
        if(LocaleManager.locale is Sv) {
            sv.state = .on
        }
        
        menu.addItem(eo);
        menu.addItem(eng);
        menu.addItem(sv);
        
        return menu
    }
    
    @objc func setOptionMode() {
        enableOption = !enableOption;
        setupMenus()
        storeMode()
    }
    
    @objc func setAutomaticTransformMode() {
        enableAutomaticTransform = !enableAutomaticTransform;
        setupMenus()
        storeMode()
    }
    
    func getModeMenu() -> NSMenu {
        let locale = LocaleManager.locale
        let menu = NSMenu();
        menu.autoenablesItems = true
        
        
        // Init eng button
        let option = NSMenuItem(title: locale.optionMode(), action: #selector(setOptionMode) , keyEquivalent: "")
        option.state = .off
        if(enableOption) {
            option.state = .on
        }
        
        // Init eo button
        let automaticTransform = NSMenuItem(title: locale.automaticTransformMode(), action: #selector(setAutomaticTransformMode) , keyEquivalent: "")
        automaticTransform.state = .off
        if(enableAutomaticTransform) {
            automaticTransform.state = .on
        }
        
        menu.addItem(option);
        menu.addItem(automaticTransform);
        
        return menu
    }
}
