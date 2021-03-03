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
    @Published var currentStats = [String: Int]()
    // ["inning": 1, "topOrBottom": 0, "strikes": 0, "fouls": 0, "balls": 0, "outs": 0, "awayScore": 0, "homeScore": 0]
    
    let defaults = UserDefaults.standard

    func addGame(_ game: Game) -> Void {
        self.allGames.append(game)
        self.selectedGame = game
        self.currentStats = ["inning": 1, "topOrBottom": 0, "strikes": 0, "fouls": 0, "balls": 0, "outs": 0, "awayScore": 0, "homeScore": 0]
        setDefaults()
    }

    func findStat(_ stat: String) -> Int {
        if let existingStat = currentStats[stat] {
            return existingStat
        }
        return setStat(stat)
    }

    func gameIndex(_ game: Game) -> Int {
        guard let index = allGames.firstIndex(of: game) else { return 99 }
        return index
    }
    
    func incrementStat(_ stat: String) -> Void {
        let conversion = ["out": "outs", "strike": "strikes", "foul": "fouls", "ball": "balls", "safe": "safe", "run": "run"]
        guard let stat = conversion[stat], let game = selectedGame else { return }
        
        switch stat {
        case "fouls", "strikes":
            foulOrStrike(stat, game: game)
        case "balls":
            addBalls(stat, game: game)
        case "outs":
            addOut()
        case "safe":
            resetFoulsStrikesBalls()
        case "run":
            scoreRun()
        default:
            currentStats[stat]! += 1
        }
    }

    func removeGame(at offsets: IndexSet) -> Void {
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
    
    func setStats(_ stats: [String: Int]) -> Void {
        currentStats = stats
        selectedGame?.currentStats = stats
    }
    
    private func setStat(_ stat: String) -> Int {
        let newStat = baseStat(stat)
        currentStats[stat] = newStat
        return newStat
    }
    
    private func baseStat(_ stat: String) -> Int {
        switch stat {
        case "inning":
            return 1
        default:
            return 0
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
    
    private func foulOrStrike(_ stat: String, game: Game) -> Void {
        if game.combineStrikesFouls() == true {
            if (findStat("fouls") + findStat("strikes") + 1) == game.numbersDictionary["strikesFoulsPerOut"]! {
                addOut()
            } else {
                currentStats[stat]!  += 1
            }
        }
    }
    
    private func addBalls(_ stat: String, game: Game) -> Void {
        if currentStats["balls"]! + 1 == game.numbersDictionary["ballsPerWalk"]! {
            resetFoulsStrikesBalls()
        } else {
            currentStats[stat]! += 1
        }
    }
    
    private func scoreRun() -> Void {
        if let topOrBottom = currentStats["topOrBottom"] {
            scoreRun(topOrBottom % 2 == 0 ? "awayScore" : "homeScore")
            resetFoulsStrikesBalls()
        }
    }
    
    private func scoreRun(_ team: String) -> Void {
        currentStats[team]! += 1
    }
    
    private func addOut() -> Void {
        resetFoulsStrikesBalls()
        if (currentStats["outs"]! + 1) == selectedGame!.numbersDictionary["outsPerInning"]! {
            if currentStats["topOrBottom"]! % 2 == 0 {
                currentStats["topOrBottom"]! += 1
            } else {
                currentStats["topOrBottom"]! += 1
                currentStats["inning"]! += 1
            }
            currentStats["outs"]! = 0
        } else {
            currentStats["outs"]! += 1
        }
    }
    
    private func resetFoulsStrikesBalls() -> Void {
        currentStats["fouls"] = 0
        currentStats["strikes"] = 0
        currentStats["balls"] = 0
    }
}
