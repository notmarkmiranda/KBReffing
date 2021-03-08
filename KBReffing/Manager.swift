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
    
    // This is what currentStats looks like on initialization
    // ["inning": 1, "topOrBottom": 0, "strikes": 0, "fouls": 0, "balls": 0, "outs": 0, "awayScore": 0, "homeScore": 0]
    var currentStats: [String: Int] {
        get {
            self.statState[currentIndex]
        }
    }
    @Published var currentIndex = 0
    @Published var statState = [["inning": 1, "topOrBottom": 0, "strikes": 0, "fouls": 0, "balls": 0, "outs": 0, "awayScore": 0, "homeScore": 0]]
    
    
    let defaults = UserDefaults.standard

    func addGame(_ game: Game) -> Void {
        self.allGames.append(game)
        self.selectedGame = game
        let initialStats = ["inning": 1, "topOrBottom": 0, "strikes": 0, "fouls": 0, "balls": 0, "outs": 0, "awayScore": 0, "homeScore": 0]
        self.statState.insert(initialStats, at: 0)
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
            var statCopy = currentStats
            statCopy[stat]! += 1
            statState.insert(statCopy, at: 0)
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
        statState.insert(stats, at: 0)
        selectedGame?.currentStats = stats
    }
    
    private func setStat(_ stat: String) -> Int {
        let newStat = baseStat(stat)
        copyAndInsert(stat: stat) { statCopy, stat in
            statCopy[stat] = newStat
        }
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
                copyAndInsert(stat: stat) { statCopy, stat in
                    increment(statCopy: &statCopy, stat: stat)
                }
            }
        }
    }
    
    private func addBalls(_ stat: String, game: Game) -> Void {
        if currentStats["balls"]! + 1 == game.numbersDictionary["ballsPerWalk"]! {
            resetFoulsStrikesBalls()
        } else {
            copyAndInsert(stat: stat) { statCopy, stat in
                increment(statCopy: &statCopy, stat: stat)
            }
        }
    }
    
    private func scoreRun() -> Void {
        if let topOrBottom = currentStats["topOrBottom"] {
            scoreRun(topOrBottom % 2 == 0 ? "awayScore" : "homeScore")
            resetFoulsStrikesBalls()
        }
    }
    
    private func scoreRun(_ team: String) -> Void {
        // #4
        copyAndInsert(stat: team) { statCopy, stat in
            increment(statCopy: &statCopy, stat: stat)
        }
    }
    
    private func copyStats() -> [String: Int] {
        let statCopy = currentStats
        return statCopy
    }
    
    private func addOut() -> Void {
        resetFoulsStrikesBalls()
        if (currentStats["outs"]! + 1) == selectedGame!.numbersDictionary["outsPerInning"]! {
            if currentStats["topOrBottom"]! % 2 == 0 {
                copyAndInsert(stat: "topOrBottom") { statCopy, stat in
                    increment(statCopy: &statCopy, stat: stat)
                }
            } else {
                copyAndInsert(stat: "") { statCopy, _ in
                    increment(statCopy: &statCopy, stat: "topOrBottom")
                    increment(statCopy: &statCopy, stat: "inning")
                }
            }
            copyAndInsert(stat: "outs") { statCopy, stat in
                setToZero(statCopy: &statCopy, stat: stat)
            }

        } else {
            copyAndInsert(stat: "outs") { statCopy, stat in
                increment(statCopy: &statCopy, stat: stat)
            }
        }
    }
    
    private func resetFoulsStrikesBalls() -> Void {
        copyAndInsert(stat: "") { statCopy, _ in
            setToZero(statCopy: &statCopy, stat: "fouls")
            setToZero(statCopy: &statCopy, stat: "strikes")
            setToZero(statCopy: &statCopy, stat: "balls")
        }
    }
    
    private func copyAndInsert(stat: String, completion: (inout [String: Int], String) -> Void) -> Void {
        var statCopy = copyStats()
        completion(&statCopy, stat)
        statState.insert(statCopy, at: 0)
    }
    
    private func setToZero(statCopy: inout [String: Int], stat: String) -> Void {
        statCopy[stat]! = 0
    }
    
    private func increment(statCopy: inout [String: Int], stat: String) -> Void {
        statCopy[stat]! += 1
    }
}
