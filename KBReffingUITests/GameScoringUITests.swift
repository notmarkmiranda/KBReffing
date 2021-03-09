//
//  GameScoringUITests.swift
//  KBReffingUITests
//
//  Created by Mark Miranda on 1/29/21.
//

import XCTest

class GameScoringUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launchArguments += ["ui-test-with-games"]
        app.launch()
        
        let gameText = app.buttons["game0"]
        gameText.tap()
    }

    func testNewGameInitialState() throws {
        let awayTeamName = app.staticTexts["awayTeamName"]
        let homeTeamName = app.staticTexts["homeTeamName"]
        let awayTeamScore = app.staticTexts["awayTeamScore"]
        let homeTeamScore = app.staticTexts["homeTeamScore"]
        let strikeFoulStat = app.staticTexts["strikeFoulStat"]
        let ballStat = app.staticTexts["ballStat"]
        let outStat = app.staticTexts["outStat"]
        let inningNumber = app.staticTexts["inningStat"]
        
        XCTAssertEqual(awayTeamName.label, "THE DINOSAURS")
        XCTAssertEqual(homeTeamName.label, "LOT LIZARDS")
        XCTAssertEqual(awayTeamScore.label, "0")
        XCTAssertEqual(homeTeamScore.label, "0")
        XCTAssertEqual(strikeFoulStat.label, "0")
        XCTAssertEqual(ballStat.label, "0")
        XCTAssertEqual(outStat.label, "0")
        XCTAssertEqual(inningNumber.label, "1")
    }
    
    func testclickingOutButtonIncrementsOuts() throws {
        let outStat = app.staticTexts["outStat"]
        XCTAssertEqual(outStat.label, "0")
        
        let outButton = app.buttons["outButton"]
        outButton.tap()
        
        XCTAssertEqual(outStat.label, "1")
    }

    func testClickingStrikeFoulButtonIncrementsStrikeFouls() throws {
        let strikeFoulStat = app.staticTexts["strikeFoulStat"]
        XCTAssertEqual(strikeFoulStat.label, "0")
        
        let strikeButton = app.buttons["strikeButton"]
        strikeButton.tap()
        
        XCTAssertEqual(strikeFoulStat.label, "1")
        
        let foulButton = app.buttons["foulButton"]
        foulButton.tap()
        
        XCTAssertEqual(strikeFoulStat.label, "2")
    }
    
    func testClickingBallButtonIncrementsBalls() throws {
        let ballStat = app.staticTexts["ballStat"]
        XCTAssertEqual(ballStat.label, "0")
        
        let ballButton = app.buttons["ballButton"]
        ballButton.tap()
        
        XCTAssertEqual(ballStat.label, "1")
    }
    
    func testTooManyFoulsChangesToAnOut() throws {
        let strikeFoulStat = app.staticTexts["strikeFoulStat"]
        XCTAssertEqual(strikeFoulStat.label, "0")
        let foulButton = app.buttons["foulButton"]
        let outStat = app.staticTexts["outStat"]
        
        foulButton.tap()
        foulButton.tap()
        foulButton.tap()
        foulButton.tap()
        foulButton.tap()
        
        XCTAssertEqual(strikeFoulStat.label, "0")
        XCTAssertEqual(outStat.label, "1")
    }
    
    func testTooManyBallsResetsBallsStrikesFouls() throws {
        let strikeButton = app.buttons["strikeButton"]
        let ballButton = app.buttons["ballButton"]
        
        let strikeFoulStat = app.staticTexts["strikeFoulStat"]
        let ballStat = app.staticTexts["ballStat"]
        let outStat = app.staticTexts["outStat"]
        
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        ballButton.tap()
        
        XCTAssertEqual(strikeFoulStat.label, "1")
        XCTAssertEqual(ballStat.label, "1")
        XCTAssertEqual(outStat.label, "1")
        
        ballButton.tap()
        ballButton.tap()
        ballButton.tap()
        
        XCTAssertEqual(strikeFoulStat.label, "0")
        XCTAssertEqual(ballStat.label, "0")
        XCTAssertEqual(outStat.label, "1")
    }
    
    func testTooManyOutsIncrementsInnings() throws {
        let topHalfImage = app.images["halfInningStat"]
        let inningStat = app.staticTexts["inningStat"]
        XCTAssertEqual(topHalfImage.label, "arrowtriangle.up.fill")
        XCTAssertEqual(inningStat.label, "1")
        
        let outButton = app.buttons["outButton"]
        outButton.tap()
        outButton.tap()
        outButton.tap()
        
        XCTAssertEqual(topHalfImage.label, "arrowtriangle.down.fill")
        XCTAssertEqual(inningStat.label, "1")
        
        outButton.tap()
        outButton.tap()
        outButton.tap()
        
        XCTAssertEqual(topHalfImage.label, "arrowtriangle.up.fill")
        XCTAssertEqual(inningStat.label, "2")
    }
    
    func testLastOutCausedByStrikesIncrementsInnings() throws {
        let topHalfImage = app.images["halfInningStat"]
        let inningStat = app.staticTexts["inningStat"]
        XCTAssertEqual(topHalfImage.label, "arrowtriangle.up.fill")
        XCTAssertEqual(inningStat.label, "1")
        
        let outButton = app.buttons["outButton"]
        outButton.tap()
        outButton.tap()
        
        let outStat = app.staticTexts["outStat"]
        XCTAssertEqual(outStat.label, "2")
        
        let strikeButton = app.buttons["strikeButton"]
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        
        XCTAssertEqual(outStat.label, "0")
        XCTAssertEqual(topHalfImage.label, "arrowtriangle.down.fill")
        XCTAssertEqual(inningStat.label, "1")
        
        outButton.tap()
        outButton.tap()
        
        XCTAssertEqual(outStat.label, "2")
        
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        XCTAssertEqual(topHalfImage.label, "arrowtriangle.up.fill")
        XCTAssertEqual(inningStat.label, "2")
    }
    
    func testSafeButtonResetsBallsStrikesOnly() throws {
        let strikeButton = app.buttons["strikeButton"]
        let foulButton = app.buttons["foulButton"]
        let ballButton = app.buttons["ballButton"]
        let outButton = app.buttons["outButton"]
        
        outButton.tap()
        strikeButton.tap()
        foulButton.tap()
        ballButton.tap()
        
        let outLabel = app.staticTexts["outStat"]
        let strikeFoulsLabel = app.staticTexts["strikeFoulStat"]
        let ballStat = app.staticTexts["ballStat"]
        
        XCTAssertEqual(outLabel.label, "1")
        XCTAssertEqual(strikeFoulsLabel.label, "2")
        XCTAssertEqual(ballStat.label, "1")
        
        let safeButton = app.buttons["safeButton"]
        
        safeButton.tap()
        
        XCTAssertEqual(outLabel.label, "1")
        XCTAssertEqual(strikeFoulsLabel.label, "0")
        XCTAssertEqual(ballStat.label, "0")
    }
    
    func testRunScoredInTopHalfIncrementsRunForAway() throws {
        // also test that it resets the count but does not reset the outs
        let strikeButton = app.buttons["strikeButton"]
        let outButton = app.buttons["outButton"]
        
        let strikeLabel = app.staticTexts["strikeFoulStat"]
        let outLabel = app.staticTexts["outStat"]
        
        outButton.tap()
        strikeButton.tap()
        XCTAssertEqual(strikeLabel.label, "1")
        XCTAssertEqual(outLabel.label, "1")
        
        let awayTeamScore = app.staticTexts["awayTeamScore"]
        XCTAssertEqual(awayTeamScore.label, "0")
        let runButton = app.buttons["runButton"]
        
        runButton.tap()
        
        XCTAssertEqual(awayTeamScore.label, "1")
        XCTAssertEqual(strikeLabel.label, "0")
        XCTAssertEqual(outLabel.label, "1")
    }
    
    func testRunScoredInBottomHalfIncrementsRunForHome() throws {
        let homeTeamScore = app.staticTexts["homeTeamScore"]
        XCTAssertEqual(homeTeamScore.label, "0")
        let outButton = app.buttons["outButton"]
        let runButton = app.buttons["runButton"]
        
        outButton.tap()
        outButton.tap()
        outButton.tap()
        
        runButton.tap()
        
        XCTAssertEqual(homeTeamScore.label, "1")
    }
    
    func testUndo() throws {
        let strikeButton = app.buttons["strikeButton"]
        strikeButton.tap()
        
        let strikeStat = app.staticTexts["strikeFoulStat"]
        
        XCTAssertEqual(strikeStat.label, "1")
        
        let undoButton = app.buttons["undoButton"]
        undoButton.tap()
        
        XCTAssertEqual(strikeStat.label, "0")
        
        // second button press to check if app crashes or not
        undoButton.tap()
        XCTAssertEqual(strikeStat.label, "0")
    }
}
