//
//  Manager.swift
//  KBReffing
//
//  Created by Mark Miranda on 1/10/21.
//

import Foundation


class Manager: ObservableObject {
    // ----------------------
    //   MARK: - PROPERTIES
    // ----------------------
    @Published var allGames: [Game] = []
    @Published var selectedGame: Game? {
        didSet {
            if selectedGame!.currentStats == nil {
                selectedGame!.currentStats = currentStats
            }
            // SOMETHING GOES HERE TO OVERWRITE
        }
    }
    @Published var currentIndex = 0
    @Published var statState = [["inning": 1, "topOrBottom": 0, "strikes": 0, "fouls": 0, "balls": 0, "outs": 0, "awayScore": 0, "homeScore": 0]]
    
    var currentStats: [String: Int] {
        get { self.statState[currentIndex] }
    }
    
    let defaults = UserDefaults.standard
    private let tracker: Tracker?

    // --------------------------------------------
    //   MARK: - Initializer, tracker for testing
    // --------------------------------------------
    
    init(tracker: Tracker? = nil) {
        self.tracker = tracker
    }
    
    // ---------------------
    //   MARK: - FUNCTIONS
    // ---------------------
    
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
    
    func buttonClick(_ stat: String) -> Void {
        let conversion = ["out": "outs", "strike": "strikes", "foul": "fouls", "ball": "balls", "safe": "safe", "run": "run", "undo": "undo", "redo": "redo"]
        guard let stat = conversion[stat], let game = selectedGame else { return }

        switch stat {
        case "undo", "redo":
            undoOrRedo(stat)
        default:
            if currentIndex != 0 {
                resetStatState()
            }
            let statCopy = statChange(stat, game)
            statState.insert(statCopy, at: 0)
        }
        saveGame()
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
        print("HERE: \(stats)")
        statState.insert(stats, at: 0)
        selectedGame?.currentStats = stats
    }
    
    func disableUndo() -> Bool {
        return currentIndex + 1 == statState.count
    }
    
    func disableRedo() -> Bool {
        return currentIndex == 0
    }
    
    func saveGame() -> Void {
        setCurrentStatsOnGame()
        setDefaults()
    }
    
    // ---------------------------
    //   MARK: - PRIVATE METHODS
    // ---------------------------
    
    private func setCurrentStatsOnGame() -> Void {
        if selectedGame != nil, selectedGame!.currentStats != currentStats  {
            selectedGame!.currentStats = currentStats
            let index = gameIndex(selectedGame!)
            guard index != 99 else { return }
            allGames[index] = selectedGame!
        }
    }
    
    private func undoOrRedo(_ stat: String) -> Void {
        if let tracker = tracker {
            tracker.undoOrRedoCalled()
        }
        switch stat {
        case "redo":
            guard (currentIndex - 1) >= 0 else { return }
            currentIndex -= 1
        case "undo":
            guard currentIndex + 1 < statState.count else {
                return
            }
            currentIndex += 1
        default:
            break
        }
    }
    
    private func resetStatState() -> Void {
        if let tracker = tracker {
            tracker.resetStatStateCalled()
        }
        let newStateArray = Array(statState[currentIndex...])
        statState = newStateArray
        currentIndex = 0
    }
    
    private func statChange(_ stat: String, _ game: Game) -> [String: Int] {
        switch stat {
        case "fouls", "strikes":
            return foulOrStrike(stat, game: game)
        case "balls":
            return addBalls(stat, game: game)
        case "outs":
            return addOut()
        case "safe":
            return resetFoulsStrikesBalls()
        case "run":
            return scoreRun()
        default:
            return currentStats
        }
    }
    
    private func setStat(_ stat: String) -> Int {
        let newStat = baseStat(stat)
        let _ = copyAndInsert(stat: stat) { statCopy, stat in
            statCopy[stat] = newStat
            return statCopy
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
    
    private func foulOrStrike(_ stat: String, game: Game) -> [String: Int] {
        if game.combineStrikesFouls() == true {
            if (findStat("fouls") + findStat("strikes") + 1) == game.numbersDictionary["strikesFoulsPerOut"]! {
                return addOut()
            } else {
                return copyAndInsert(stat: stat, completion: increment(statCopy:stat:))
            }
        } else {
            // this is if strikes and fouls are not combined
            return currentStats
        }
    }
    
    private func addBalls(_ stat: String, game: Game) -> [String: Int] {
        if currentStats["balls"]! + 1 == game.numbersDictionary["ballsPerWalk"]! {
            return resetFoulsStrikesBalls()
        } else {
            return copyAndInsert(stat: stat, completion: increment(statCopy:stat:))
        }
    }
    
    private func scoreRun() -> [String: Int] {
        if let topOrBottom = currentStats["topOrBottom"] {
            let statCopy = scoreRun(topOrBottom % 2 == 0 ? "awayScore" : "homeScore")
            return resetFoulsStrikesBalls(stats: statCopy)
        }
        return currentStats
    }
    
    private func scoreRun(_ team: String) -> [String: Int] {
        return copyAndInsert(stat: team, completion: increment(statCopy:stat:))
    }
    
    private func copyStats() -> [String: Int] {
        let statCopy = currentStats
        return statCopy
    }
    
    private func addOut() -> [String: Int] {
        var statCopy = resetFoulsStrikesBalls()
        if (currentStats["outs"]! + 1) == selectedGame!.numbersDictionary["outsPerInning"]! {
            statCopy = setToZero(statCopy: &statCopy, stat: "outs")
            if currentStats["topOrBottom"]! % 2 == 0 {
                return copyAndInsert(stat: "topOrBottom", stats: statCopy, completion: increment(statCopy:stat:))
            } else {
                return copyAndInsert(stat: "", stats: statCopy) { statCopy, _ in
                    statCopy = increment(statCopy: &statCopy, stat: "topOrBottom")
                    statCopy = increment(statCopy: &statCopy, stat: "inning")
                    return statCopy
                }
            }
        } else {
            return copyAndInsert(stat: "outs", stats: statCopy, completion: increment(statCopy:stat:))
        }
    }
    
    private func resetFoulsStrikesBalls(stats: [String: Int]? = nil) -> [String: Int] {
        return copyAndInsert(stat: "", stats: stats) { statCopy, _ in
            statCopy = setToZero(statCopy: &statCopy, stat: "fouls")
            statCopy = setToZero(statCopy: &statCopy, stat: "strikes")
            statCopy = setToZero(statCopy: &statCopy, stat: "balls")
            return statCopy
        }
    }
    
    private func copyAndInsert(stat: String, stats: [String: Int]? = nil, completion: (inout [String: Int], String) -> [String: Int]) -> [String: Int] {
        var statCopy = stats ?? copyStats()
        return completion(&statCopy, stat)
    }
    
    private func setToZero(statCopy: inout [String: Int], stat: String) -> [String: Int] {
        statCopy[stat]! = 0
        return statCopy
    }
    
    private func increment(statCopy: inout [String: Int], stat: String) -> [String: Int] {
        statCopy[stat]! += 1
        return statCopy
    }
}
