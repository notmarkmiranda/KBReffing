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
}
