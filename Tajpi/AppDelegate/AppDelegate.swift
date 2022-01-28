//
//  AppDelegate.swift
//  tajpi
//
//  Created by Fritiof Rusck on 2022-01-25.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!
    var locale = LocaleState(id: "locale", value: English());
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Init Keyboard
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            let img = NSImage(named: NSImage.Name("StatusIcon"))!
            img.size = NSMakeSize(18.0, 18.0)
            button.image = img
        }
        
        setupMenus()
        
        onNewUpdate {
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
        paused.change(!paused.value)
        setupMenus()
    }
    
    @objc func openBug() {
        let url = URL(string: "https://github.com/PumpedSardines/Tajpi/issues")!
        NSWorkspace.shared.open(url)
    }
    
    @objc func openNewVersion() {
        if let url = newVersion {
            let url = URL(string: url)!
            NSWorkspace.shared.open(url)
        }

    }
    
    func setupMenus() {
        // Create the menu
        let menu = NSMenu()
        menu.autoenablesItems = false // This i needed for isEnabled to work
        let localeMenu = getLocaleMenu();
        let modeMenu = getModeMenu();
        
        // Create a info text that diplays current status
        let info = NSMenuItem(title: locale.value.state(paused: paused.value), action: nil, keyEquivalent: "")
        info.isEnabled = false
        menu.addItem(info)
        
        menu.addItem(NSMenuItem.separator())
        
        //============ Application Mode ============
        // Create a button to enable or disable execution
        let runningButton = NSMenuItem(title: locale.value.changeState(paused: paused.value), action: #selector(onMenuRunningClick), keyEquivalent: "")
        menu.addItem(runningButton)
        
        let modeButton = NSMenuItem(title: locale.value.modes(), action: nil, keyEquivalent: "")
        menu.addItem(modeButton)
        menu.setSubmenu(modeMenu, for: modeButton)
        
        //============ Lower settings menu ============
        menu.addItem(NSMenuItem.separator())
        
        if let url = newVersion {
            let updateButton = NSMenuItem(title: locale.value.updateAvailable(), action: #selector(openNewVersion), keyEquivalent: "")
            menu.addItem(updateButton)
        }
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if let appVersion = appVersion {
            let version = NSMenuItem(title: locale.value.currentVersion(version: appVersion), action: nil, keyEquivalent: "")
            version.isEnabled = false;
            menu.addItem(version)
        }

        let bugButton = NSMenuItem(title: locale.value.foundABug(), action: #selector(openBug), keyEquivalent: "")
        menu.addItem(bugButton)

        let languageButton = NSMenuItem(title: locale.value.changeLanguage(), action: nil, keyEquivalent: "")
        menu.addItem(languageButton)
        menu.setSubmenu(localeMenu, for: languageButton)
        
        
        
        menu.addItem(NSMenuItem.separator())
        
        // Add a quit button
        menu.addItem(NSMenuItem(title: locale.value.quit(), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        
        statusItem.menu = menu
    }
    
    @objc func setLanguageEnglish() {
        locale.change(English())
        setupMenus()
    }
    
    @objc func setLanguageEsperanto() {
        locale.change(Esperanto())
        setupMenus()
    }
    
    @objc func setLanguageSwedish() {
        locale.change(Swedish())
        setupMenus()
    }
    
    func getLocaleMenu() -> NSMenu {
        let menu = NSMenu();
        menu.autoenablesItems = true
        
        let languages = [
            // Language, function to switch, if it's selected
            (English(),  #selector(setLanguageEnglish), locale.value is English),
            (Esperanto(),  #selector(setLanguageEsperanto), locale.value is Esperanto),
            (Swedish(),  #selector(setLanguageSwedish), locale.value is Swedish),
        ] as [(Locale, Selector, Bool)];
        
        
        
        for language in languages {
            // Init English button
            let btn = NSMenuItem(title: language.0.name, action: language.1, keyEquivalent: "")
            btn.isEnabled = true;
            btn.state = .off
            if(language.2) {
                btn.state = .on
            }
            menu.addItem(btn);
        }
        
        return menu
    }
    
    @objc func setOptionMode() {
        option.change(!option.value);
        setupMenus()
    }
    
    @objc func setAutomaticTransformMode() {
        automaticTransform.change(!automaticTransform.value);
        setupMenus()
    }
    
    func getModeMenu() -> NSMenu {
        let menu = NSMenu();
        menu.autoenablesItems = true
        
        // Init eng button
        let optionButton = NSMenuItem(title: locale.value.modeOption(), action: #selector(setOptionMode) , keyEquivalent: "")
        optionButton.state = .off
        if(option.value) {
            optionButton.state = .on
        }
        
        // Init eo button
        let automaticTransformButton = NSMenuItem(title: locale.value.modeAutomaticTransform(), action: #selector(setAutomaticTransformMode) , keyEquivalent: "")
        automaticTransformButton.state = .off
        if(automaticTransform.value) {
            automaticTransformButton.state = .on
        }
        
        menu.addItem(optionButton);
        menu.addItem(automaticTransformButton);
        
        return menu
    }
}
