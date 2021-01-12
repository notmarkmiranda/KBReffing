//
//  KBReffingApp.swift
//  KBReffing
//
//  Created by Mark Miranda on 11/23/20.
//

import SwiftUI

@main
struct KBReffingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Manager())
        }
    }
}
