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
    
    private func getGamesFromDefaults() throws -> [Game] {
        let games = defaults.object(forKey: "games") as! Data
        return try decoder.decode(Array.self, from: games) as [Game]
    }
}
