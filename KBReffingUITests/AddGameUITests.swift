//
//  AddGameUITests.swift
//  KBReffingUITests
//
//  Created by Mark Miranda on 1/22/21.
//

import XCTest

class AddGameUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testAddGameUITest() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-games", "nil"]
        app.launch()
        
        let addGameButton = app.navigationBars.buttons["plus"]
        addGameButton.tap()
        
        let goButton = app.buttons["goButton"]
        XCTAssertEqual(goButton.isEnabled, false)
        sleep(10)
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
        app.keys["s"].tap()
        
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
        app.keys["s"].tap()
                
        goButton.tap()
        
        let awayTeamText = app.staticTexts["awayTeamName"]
        let homeTeamText = app.staticTexts["homeTeamName"]
        let exp = expectation(description: "Test after 5 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 2.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(awayTeamText.exists)
            XCTAssertEqual(awayTeamText.label, "DINOSAURS")
            XCTAssert(homeTeamText.exists)
            XCTAssertEqual(homeTeamText.label, "LOT LIZARDS")
        } else {
            XCTFail("Delay interrupted")
        }
        
        
    }

}
