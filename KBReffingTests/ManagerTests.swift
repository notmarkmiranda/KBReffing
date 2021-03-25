//
//  ManagerTests.swift
//  KBReffingTests
//
//  Created by Mark Miranda on 1/18/21.
//

import XCTest
@testable import KBReffing

class ManagerTests: XCTestCase {
    let manager = Manager()
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let cal = Calendar.current
    let uuid = UUID()
    
    var game: Game {
        let dateComp = DateComponents(
            year: 2015,
            month: 05,
            day: 09
        )
        let gameDate = cal.date(from: dateComp)
        
        return Game(id: uuid, date: gameDate!, awayTeamName: "Super Duper", homeTeamName: "Lot Lizards", numbersDictionary: ["numberOfInnings": 9, "outsPerInning": 3, "strikesFoulsPerOut": 5, "strikesPerOut": 3, "foulsPerOut": 4, "ballsPerWalk": 4],booleanDictionary: ["combineStrikesFouls": true, "canFoulOut": true])
    }
    
    override func setUp() {
        defaults.removeObject(forKey: "games")
    }
    
    override func tearDown() {
        defaults.removeObject(forKey: "games")
    }
    
    func testAddGameSetsUserDefaults() throws {
        XCTAssertNil(defaults.object(forKey: "games"))
        manager.addGame(game)
        let games = try getGamesFromDefaults()
        
        XCTAssertEqual([game], manager.allGames)
        XCTAssert(games.count == 1)
    }
    
    func testRemoveGameSetsUserDefaults() throws {
        manager.addGame(game)
        let i: IndexSet = [manager.allGames.firstIndex { $0 == game }!]
        manager.removeGame(at: i)
        let games = try getGamesFromDefaults()
        
        XCTAssert(games.count == 0)
    }
    
    func testSetGamesWhenNoGamesExist() throws {
        try manager.setGames()
        XCTAssertEqual(manager.allGames, [])
    }
    
    func testSetGamesWhenGamesExist() throws {
        do {
            let encodedGames = try encoder.encode([game])
            UserDefaults.standard.set(encodedGames, forKey: "games")
        } catch {
            print(error)
        }
        
        try manager.setGames()
        XCTAssert(manager.allGames.count == 1)
    }
    
    func testGameIndexWhenItExists() throws {
        manager.addGame(game)
        XCTAssertEqual(manager.gameIndex(game), 0)
    }
    
    func testGameIndexWhenItDoesNotExist() throws {
        XCTAssertEqual(manager.gameIndex(game), 99)
    }
    
    func testFindStatWhenStatExists() throws {
        XCTAssertEqual(manager.findStat("outs"), 0)
    }
    
    func testFindStateWhenStatDoesNotExist() throws {
        XCTAssertEqual(manager.findStat("superDuper"), 0)
    }
    
    func testButtonClickUndoCallsUndoOrRedo() throws {
        let tracker = Tracker()
        let newManager = Manager(tracker: tracker)
        newManager.selectedGame = Game.example
        
        newManager.buttonClick("undo")
        XCTAssert(tracker.undoOrRedoFunctionCalled)
    }
    
    func testButtonClickRedoCallsUndoOrRedo() throws {
        let tracker = Tracker()
        let newManager = Manager(tracker: tracker)
        newManager.selectedGame = Game.example
        
        newManager.buttonClick("redo")
        XCTAssert(tracker.undoOrRedoFunctionCalled)
    }
    
    func testButtonClickWhenCurrentIndexIsZero() throws {
        manager.selectedGame = Game.example
        manager.allGames = [Game.example]
        manager.currentIndex = 0
        print(manager.statState)
        
        manager.buttonClick("out")
        XCTAssertEqual(manager.statState.count, 2)
    }
    
    func testButtonClickWhenCurrentIndexIsNotZero() throws {
        let tracker = Tracker()
        let newManager = Manager(tracker: tracker)
        newManager.addGame(Game.example)
        
        let dupStats = newManager.statState[0]
        newManager.statState = [dupStats, dupStats]
        newManager.currentIndex = 1
        
        newManager.buttonClick("out")
        XCTAssert(tracker.resetStatStateFunctionCalled)
        XCTAssertEqual(newManager.currentIndex, 0)
    }
    
    func testGameStateAlwaysMimcsCurrentStats() throws {
        manager.selectedGame = Game.example
        XCTAssertEqual(manager.selectedGame?.currentStats, manager.currentStats)
        manager.buttonClick("out")
        
        XCTAssertEqual(manager.selectedGame?.currentStats, manager.currentStats)
    }
    
    func testSelectedGameMatchesAllGames() throws {
        manager.selectedGame = Game.example
        manager.allGames = [Game.example]
        manager.buttonClick("out")
        
        let selectedGame = manager.selectedGame
        let gameIndex = manager.gameIndex(selectedGame!)
        
        XCTAssertEqual(selectedGame!.currentStats!, manager.allGames[gameIndex].currentStats)
    }
    
    func testGameInDefaultsHasStatsThatMatch() throws {
        manager.selectedGame = Game.example
        manager.allGames = [Game.example]
        
        manager.buttonClick("out")

        let selectedGame = manager.selectedGame
        let games = try getGamesFromDefaults()
        XCTAssertEqual(games[0], selectedGame)
    }
    
    private func getGamesFromDefaults() throws -> [Game] {
        let games = defaults.object(forKey: "games") as! Data
        return try decoder.decode(Array.self, from: games) as [Game]
    }
}
