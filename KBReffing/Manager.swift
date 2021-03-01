//
//  Manager.swift
//  KBReffing
//
//  Created by Mark Miranda on 1/10/21.
//

import Foundation

class Manager: ObservableObject {
    @Published var allGames: [Game] = []
    @Published var selectedGame: Game?
    @Published var currentStats: [String: Int] = ["inning": 1, "topOrBottom": 0, "strikes": 0, "fouls": 0, "balls": 0, "outs": 0, "awayScore": 0, "homeScore": 0]

    let defaults = UserDefaults.standard
    
    func addGame(_ game: Game) {
        self.allGames.append(game)
        self.selectedGame = game
        setDefaults()
    }
    
    func gameIndex(_ game: Game) -> Int {
        guard let index = allGames.firstIndex(of: game) else { return 99 }
        return index
    }
    
    func removeGame(at offsets: IndexSet) {
        allGames.remove(atOffsets: offsets)
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
