//
//  RandomUserUITests.swift
//  RandomUserUITests
//
//  Created by SV on 2015-10-08.
//  Copyright © 2015 WHMG Inc. All rights reserved.
//

import XCTest

class RandomUserUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserSelectedSaveDeclined () {
      let app = XCUIApplication()
      let listOfUsersTableTable = app.tables["List of Users Table"]
      listOfUsersTableTable.staticTexts.elementBoundByIndex(0).tap()
      app.navigationBars["RandomUser.ListView"].buttons["Save"].tap()
      app.alerts["Are Sure?"].collectionViews.buttons["No"].tap()
    }
  
    func testNoUserSelected () {
      
      let app = XCUIApplication()
      app.navigationBars["RandomUser.ListView"].buttons["Save"].tap()
      app.alerts["Nothing to Save"].collectionViews.buttons["OK"].tap()
      
    }
  
}
