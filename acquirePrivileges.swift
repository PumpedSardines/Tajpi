import Foundation
import Cocoa


class AccessibilityAuthorization {
    
    public func checkAccessibility(completion: @escaping () -> Void) {
        if !AXIsProcessTrusted() {
            
            
            AXUIElementCreateApplication(getpid())
            
            
            let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
            let privOptions = [trusted: true]
            let accessEnabled = AXIsProcessTrustedWithOptions(privOptions as CFDictionary)
            print(accessEnabled)
            
            pollAccessibility(completion: completion)
        } else {
            completion()
        }
    }
    
    private func pollAccessibility(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if AXIsProcessTrusted() {
                completion()
            } else {
                self.pollAccessibility(completion: completion)
            }
        }
    }
}
