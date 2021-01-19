//
//  Manager.swift
//  KBReffing
//
//  Created by Mark Miranda on 1/10/21.
//

import Foundation

class Manager: ObservableObject {
    @Published var allGames: [Game] = []
    var games: [Game] = []
    
    init(games: [Game] = []) {
        self.games = games
    }
    
    func addGame(_ game: Game) {
        allGames.append(game)
        setDefaults()
    }
    
    func removeGame(at offsets: IndexSet) {
        allGames.remove(atOffsets: offsets)
        setDefaults()
    }
    
    private func setDefaults() -> Void {
        let encoder = JSONEncoder()
        
        do {
            let encodedGames = try encoder.encode(allGames)
            UserDefaults.standard.set(encodedGames, forKey: "games")
        } catch {
            print(error)
        }
    }
}
