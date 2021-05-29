//
//  KBReffingApp.swift
//  KBReffing
//
//  Created by Mark Miranda on 11/23/20.
//

import SwiftUI

@main
struct KBReffingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        if CommandLine.arguments.contains("ui-test-with-games") {
            let defaults = UserDefaults.standard
            let encoder = JSONEncoder()
            
            defaults.removeObject(forKey: "games")
            do {
                let encodedGames = try encoder.encode([Game.example])
                defaults.set(encodedGames, forKey: "games")
            } catch {
                print(error)
            }
            
        }
        return true
    }
}
