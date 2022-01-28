//
//  State.swift
//  Tajpi
//
//  Created by Fritiof Rusck on 2022-01-27.
//

import Foundation

private let defaults = UserDefaults.standard
private let key = "com.fritiofrusck.tajpi."

protocol State {
    associatedtype T
    var value: T  { get set };
    var id: String { get set };
    
    func serialize(_ val: T) -> String;
    func deserialize(_ raw: String) -> T;
    init(id: String, value: T)
}

extension State {
    mutating func load() {
        if let v = getLoadable() {
            value = v;
        }
    }
    
    internal func getLoadable() -> T? {
        if let v = defaults.string(forKey: key + id) {
            return deserialize(v);
        }
        
        return nil;
    }
    
    mutating func change(_ val: T) {
        value = val;
        defaults.set(serialize(value), forKey: key + id);
    }
}
