//
//  EditStatsUITests.swift
//  KBReffingUITests
//
//  Created by Mark Miranda on 4/12/21.
//

import XCTest

class EditStatsUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments += ["ui-test-with-games"]
        app.launch()
        
        let gameText = app.buttons["game0"]
        gameText.tap()
    }

    func testCanEditStrikes() throws {
        let strikeStat = app.staticTexts["strikeFoulStat"]
        let strikeButton = app.buttons["strikeButton"]
        strikeButton.tap()
        
        XCTAssertEqual(strikeStat.label, "1")
        let editButton = app.buttons["editStatsButton"]
        editButton.tap()
        
        let strikeStepperPlus = app.otherElements["strikeAndFoulStepper"].coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        
        strikeStepperPlus.tap()
    
        let saveButton = app.buttons["saveStatsButton"]
        
        saveButton.tap()
        
        XCTAssertEqual(strikeStat.label, "2")
    }

}
