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
        app.launch()
        
        let navTitle = app.navigationBars["Games"]
        let noGamesText = app.staticTexts["noGames"]
        
        XCTAssert(navTitle.exists)
        XCTAssert(noGamesText.exists)
        XCTAssertEqual(noGamesText.label, "There are no games.")
    }

}
