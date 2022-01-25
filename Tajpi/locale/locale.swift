//
//  locale.swift
//  tajpi
//
//  Created by Fritiof Rusck on 2022-01-25.
//

import Foundation

protocol Locale {
    static func name() -> String
    func running(_ running: Bool) -> String
    func info(_ running: Bool) -> String
    func quit() -> String
    func language() -> String
}
