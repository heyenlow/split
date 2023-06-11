//
//  Models.swift
//  split
//
//  Created by Konrad Heyen on 6/11/23.
//

import Foundation

struct AppItem: Codable {
    let id: String
    let type: String
    let bundle: String
    let version: String
}

struct AppDefs: Codable {
    let launcher: Launcher
}

struct Launcher: Codable {
    let menu: [MenuOption]
    let apps: [AppItem]
}

struct MenuOption: Codable {
    let title: String
    let target: String
}
