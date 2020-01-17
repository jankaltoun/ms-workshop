//
//  FeedTests.swift
//  LamstagramUITests
//
//  Created by Jan Kaltoun on 15/01/2020.
//  Copyright © 2020 Jan Kaltoun. All rights reserved.
//

import XCTest

class FeedTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testFeed() {
        let app = XCUIApplication()
        app.launch()
        
        let dataLoaded = app.staticTexts["barallama"].waitForExistence(timeout: 2)
        XCTAssert(dataLoaded)
        
        XCTAssert(app.tables.cells.count == 12)
        
        app.cells.firstMatch.tap()
        
        let photoDetailPresented = app.images["photo_detail"].waitForExistence(timeout: 1)
        XCTAssert(photoDetailPresented)
    }
}
