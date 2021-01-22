//
//  Manager.swift
//  KBReffing
//
//  Created by Mark Miranda on 1/10/21.
//

import Foundation

class Manager: ObservableObject {
    @Published var allGames: [Game] = []
    let defaults = UserDefaults.standard
    
    func addGame(_ game: Game) {
        self.allGames.append(game)
        print("HOW: \(self.allGames)")
        setDefaults()
    }
    
    func removeGame(at offsets: IndexSet) {
        allGames.remove(atOffsets: offsets)
        print(allGames)
        setDefaults()
    }
    
    func setGames() throws {
        if let games = defaults.object(forKey: "games") as? Data {
            let decoder = JSONDecoder()
            if let decodedGames = try? decoder.decode(Array<Game>.self, from: games) {
                allGames = decodedGames
            }
        }
    }
    
    private func setDefaults() -> Void {
        let encoder = JSONEncoder()
        
        do {
            let encodedGames = try encoder.encode(allGames)
            defaults.set(encodedGames, forKey: "games")
        } catch {
            print(error)
        }
    }
}
