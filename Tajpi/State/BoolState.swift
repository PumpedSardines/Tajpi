//
//  Mode.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation

class BoolState: State {
    var value: Bool = false;
    var id: String = ""
    
    required init(id: String, value: Bool) {
        self.id = id;
        
        if let v = getLoadable() {
            self.value = v;
        } else {
            self.value = value;
        }
    }
    
    func serialize(_ val: Bool) -> String {
        return val ? "true" : "false";
    }
    
    func deserialize(_ raw: String) -> Bool {
        return (raw == "true") ? true : false;
    }
    
    typealias T = Bool;
}
