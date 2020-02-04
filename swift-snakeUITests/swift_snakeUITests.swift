//
//  swift_snakeUITests.swift
//  swift-snakeUITests
//
//  Created by Weihang Lo on 7/4/16.
//  Copyright © 2016 Weihang Lo. All rights reserved.
//

import XCTest

class swift_snakeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
        XCUIDevice.shared.orientation = UIDeviceOrientation.portrait
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testButtonTap() {
        
        let app = XCUIApplication()
        let button = app.buttons["New Game"]
        
        XCTAssertTrue(button.isEnabled)
        button.tap()
        
        expectation(for: NSPredicate(format: "enabled == true") , evaluatedWith: button, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
