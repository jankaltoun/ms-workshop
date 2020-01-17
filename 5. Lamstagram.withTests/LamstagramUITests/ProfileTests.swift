//
//  ProfileTests.swift
//  LamstagramUITests
//
//  Created by Jan Kaltoun on 15/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import XCTest

class ProfileTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testProfile() {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars.buttons["Profile"].tap()
        
        let dataLoaded = app.staticTexts["Barack O. Llama"].waitForExistence(timeout: 2)
        XCTAssert(dataLoaded)
        
        let numberOfHeaderCells = app.cells.matching(identifier: "header_cell").count
        XCTAssert(numberOfHeaderCells == 1)
        
        let numberOfFriendCells = app.cells.matching(identifier: "friend_cell").count
        XCTAssert(numberOfFriendCells == 6)
        
        let numberOfPhotoCells = app.cells.matching(identifier: "photo_cell").count
        XCTAssert(numberOfPhotoCells == 7)
    }
}
