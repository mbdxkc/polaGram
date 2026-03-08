//
//  polaGramApp.swift
//  polaGram
//
//  Created by valdez campos on 2/7/26.
//  mediabrilliance.io
//

import SwiftUI
import SwiftData

@main
struct polaGramApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedPola.self)
    }
}
