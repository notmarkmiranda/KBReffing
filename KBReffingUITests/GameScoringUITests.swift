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
        sleep(1)
        strikeButton.tap()
        sleep(1)
        strikeButton.tap()
        sleep(1)
        strikeButton.tap()
        sleep(1)
        strikeButton.tap()
        sleep(1)
        strikeButton.tap()
        sleep(1)
        ballButton.tap()
//        sleep(1)
        
//        XCTAssertEqual(strikeFoulStat.label, "1")
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
        XCTAssertEqual(topHalfImage.label, "Triangle Arrow Up")
        XCTAssertEqual(inningStat.label, "1")
        
        let outButton = app.buttons["outButton"]
        outButton.tap()
        outButton.tap()
        outButton.tap()
        
        XCTAssertEqual(topHalfImage.label, "Triangle Arrow Down")
        XCTAssertEqual(inningStat.label, "1")
        
        outButton.tap()
        outButton.tap()
        outButton.tap()
        
        XCTAssertEqual(topHalfImage.label, "Triangle Arrow Up")
        XCTAssertEqual(inningStat.label, "2")
    }
    
    func testLastOutCausedByStrikesIncrementsInnings() throws {
        let topHalfImage = app.images["halfInningStat"]
        let inningStat = app.staticTexts["inningStat"]
        XCTAssertEqual(topHalfImage.label, "Triangle Arrow Up")
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
        XCTAssertEqual(topHalfImage.label, "Triangle Arrow Down")
        XCTAssertEqual(inningStat.label, "1")
        
        outButton.tap()
        outButton.tap()
        
        XCTAssertEqual(outStat.label, "2")
        
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        strikeButton.tap()
        XCTAssertEqual(topHalfImage.label, "Triangle Arrow Up")
        XCTAssertEqual(inningStat.label, "2")
    }
    
    func testSafeButtonResetsBallsStrikesOnly() throws {
        let strikeButton = app.buttons["strikeButton"]
        let foulButton = app.buttons["foulButton"]
        let ballButton = app.buttons["ballButton"]
        let outButton = app.buttons["outButton"]
        
        print(outButton.debugDescription)
        outButton.tap()
        sleep(1)
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
        
        sleep(1)
        outButton.tap()
        sleep(1)
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
        sleep(1)
        strikeButton.tap()
        
        let strikeStat = app.staticTexts["strikeFoulStat"]
        
        XCTAssertEqual(strikeStat.label, "1")
        
        let undoButton = app.buttons["undoButton"]
        undoButton.tap()
        
        XCTAssertEqual(strikeStat.label, "0")
    }
    
    func testUndoMoreTimesThanExists() throws {
        let strikeButton = app.buttons["strikeButton"]
        sleep(1)
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
    
    func testRedo() throws {
        let outButton = app.buttons["outButton"]
        let undoButton = app.buttons["undoButton"]
        let redoButton = app.buttons["redoButton"]
        sleep(1)
        outButton.tap()
        
        let outStat = app.staticTexts["outStat"]
        XCTAssertEqual(outStat.label, "1")
        
        undoButton.tap()
        XCTAssertEqual(outStat.label, "0")
        
        redoButton.tap()
        XCTAssertEqual(outStat.label, "1")
    }
    
    func testRedoTooManyTimes() throws {
        let outButton = app.buttons["outButton"]
        let undoButton = app.buttons["undoButton"]
        let redoButton = app.buttons["redoButton"]
        sleep(1)
        outButton.tap()
        
        let outStat = app.staticTexts["outStat"]
        XCTAssertEqual(outStat.label, "1")
        
        undoButton.tap()
        XCTAssertEqual(outStat.label, "0")
        
        redoButton.tap()
        XCTAssertEqual(outStat.label, "1")
        
        // second button press to check if app crashes or not
        redoButton.tap()
        XCTAssertEqual(outStat.label, "1")
    }
    
    func testUndoAndNewStatClickRemovesRedoAbility() throws {
        let outButton = app.buttons["outButton"]
        let undoButton = app.buttons["undoButton"]
        let redoButton = app.buttons["redoButton"]
        sleep(1)
        outButton.tap()
        
        let outStat = app.staticTexts["outStat"]
        XCTAssertEqual(outStat.label, "1")
        
        undoButton.tap()
        XCTAssertEqual(outStat.label, "0")
        
        outButton.tap()
        XCTAssertEqual(outStat.label, "1")
        
        redoButton.tap()
        XCTAssertEqual(outStat.label, "1")
        
        outButton.tap()
        XCTAssertEqual(outStat.label, "2")
    }
    
//    func testClosingAppWithScoresCanReopenWithScores() throws {
//        let outButton = app.buttons["outButton"]
//        let outStat = app.staticTexts["outStat"]
//        
//        outButton.tap()
//        outButton.tap()
//        XCTAssertEqual(outStat.label, "2")
//        sleep(1)
//        app.terminate()
//        app.activate()
//        sleep(1)
//        let gameText = app.buttons["game0"]
//        gameText.tap()
//        
//        XCTAssertEqual(outStat.label, "2")
//    }
    
    func testDisabledUndoButtonWhenNoUndoIsPossible() throws {
        let undoButton = app.buttons["undoButton"]
        XCTAssertEqual(undoButton.isEnabled, false)
        
        let outButton = app.buttons["outButton"]
        outButton.tap()
        
        XCTAssertEqual(undoButton.isEnabled, true)
    }
    
    func testDisabledRedoButtonWhenNoRedoIsPossible() throws {
        let redoButton = app.buttons["redoButton"]
        XCTAssertEqual(redoButton.isEnabled, false)
        
        let outButton = app.buttons["outButton"]
        let undoButton = app.buttons["undoButton"]
        outButton.tap()
        undoButton.tap()
        
        XCTAssertEqual(redoButton.isEnabled, true)
    }
 
    func testChangingGamesAndCheckingNewStats() throws {
        let outButton = app.buttons["outButton"]
        sleep(1)
        outButton.tap()
        
        let outStat = app.staticTexts["outStat"]
        XCTAssertEqual(outStat.label, "1")
        
        let backButton = app.navigationBars.buttons["backButton"]
        sleep(1)
        backButton.tap()
        
        let addGameButton = app.navigationBars.buttons["add"]
        sleep(1)
        addGameButton.tap()
        
        let goButton = app.buttons["goButton"]
        XCTAssertEqual(goButton.isEnabled, false)
        sleep(1)
        let awayTeamField = app.textFields["awayTeamField"]
        awayTeamField.tap()
        sleep(1)
        app.keys["D"].tap()
        app.keys["i"].tap()
        app.keys["n"].tap()
        app.keys["o"].tap()
        app.keys["s"].tap()
        app.keys["a"].tap()
        app.keys["u"].tap()
        app.keys["r"].tap()
        app.keys["z"].tap()
        
        let homeTeamField = app.textFields["homeTeamField"]
        homeTeamField.tap()
        sleep(1)
        app.keys["L"].tap()
        app.keys["o"].tap()
        app.keys["t"].tap()
        app.keys["space"].tap()
        app.keys["l"].tap()
        app.keys["i"].tap()
        app.keys["z"].tap()
        app.keys["a"].tap()
        app.keys["r"].tap()
        app.keys["d"].tap()
        app.keys["z"].tap()
                
        goButton.tap()
        
        let awayTeamText = app.staticTexts["awayTeamName"]
        let homeTeamText = app.staticTexts["homeTeamName"]
        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 2.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(awayTeamText.exists)
            XCTAssertEqual(awayTeamText.label, "DINOSAURZ")
            XCTAssert(homeTeamText.exists)
            XCTAssertEqual(homeTeamText.label, "LOT LIZARDZ")
            
            let outStat = app.staticTexts["outStat"]
            XCTAssertEqual(outStat.label, "0")
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
