//
//  KBReffingUITests.swift
//  KBReffingUITests
//
//  Created by Mark Miranda on 11/23/20.
//

import XCTest

class KBReffingUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testInitialViewState() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-games", "nil"]
        app.launch()
        
        let navTitle = app.navigationBars["Games"]
//        let noGamesText = app.staticTexts["noGames"]
        
        XCTAssert(navTitle.exists)
        // Removing emptyState for the time being.
        // TODO: Fix emptyState when list is empty
//        XCTAssert(noGamesText.exists)
//        XCTAssertEqual(noGamesText.label, "There are no games.")
    }
    
    func testInitialViewStateWithGames() throws {
        let app = XCUIApplication()
        
        app.launchArguments += ["ui-test-with-games"]
        app.launch()
        
        let gameText = app.buttons["game0"]
        XCTAssertNotNil(gameText.label.range(of: "The Dinosaurs"))
        XCTAssertNotNil(gameText.label.range(of: "Lot Lizards"))
    }
}
