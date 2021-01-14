//
//  GameTests.swift
//  KBReffingTests
//
//  Created by Mark Miranda on 1/13/21.
//

import XCTest
@testable import KBReffing

class GameTests: XCTestCase {
    func game(status: GameStatus = GameStatus.notStarted, numberOfInnings: Int?) -> Game {
        let cal = Calendar.current
        let dateComp = DateComponents(
            year: 2015,
            month: 05,
            day: 09
        )
        let gameDate = cal.date(from: dateComp)
        
        if let innings = numberOfInnings {
            return Game(id: UUID(), date: gameDate!, awayTeamName: "Super Duper", homeTeamName: "Lot Lizards", status: status, numbersDictionary: ["numberOfInnings": innings, "outsPerInning": 3, "strikesFoulsPerOut": 5, "strikesPerOut": 3, "foulsPerOut": 4, "ballsPerWalk": 4], booleanDictionary: ["combineStrikesFouls": true, "canFoulOut": true])
        } else {
            return Game(id: UUID(), date: gameDate!, awayTeamName: "Super Duper", homeTeamName: "Lot Lizards", status: status, numbersDictionary: ["outsPerInning": 3, "strikesFoulsPerOut": 5, "strikesPerOut": 3, "foulsPerOut": 4, "ballsPerWalk": 4], booleanDictionary: ["combineStrikesFouls": true, "canFoulOut": true])
        }
        
    }

    func testFormattedDate() throws {
        XCTAssertEqual(game(numberOfInnings: nil).formattedDate(), "May 9, 2015")
    }
    
    func testStringStatusNotStarted() throws {
        XCTAssertEqual(game(numberOfInnings: nil).stringStatus(), "Not Started")
    }
    
    func testStringStatusInProgress() throws {
        let status = GameStatus.inProgress
        XCTAssertEqual(game(status: status, numberOfInnings: nil).stringStatus(), "In Progress")
    }
    
    func testStringStatusFinished() throws {
        let status = GameStatus.finished
        XCTAssertEqual(game(status: status, numberOfInnings: nil).stringStatus(), "Finished")
    }
    
    func testNumberOfInningsReturnsNumber() throws {
        XCTAssertEqual(game(numberOfInnings: 1).numberOfInnings(), 1)
    }
    
    func testNumberOfInningsReturnsNinetyNine() throws {
        XCTAssertEqual(game(numberOfInnings: nil).numberOfInnings(), 99)
    }
}
