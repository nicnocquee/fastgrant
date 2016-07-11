//
//  GrantPermissionScriptSampleUITests.swift
//  GrantPermissionScriptSampleUITests
//
//  Created by Nico Prananta on 7/11/16.
//  Copyright © 2016 DelightfulDev. All rights reserved.
//

import XCTest

class GrantPermissionScriptSampleUITests: XCTestCase {
        
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
    
    func testPhotosAccess() {
        
        let app = XCUIApplication()
        
        let photosExpect = expectationWithDescription("Photos granted exists")

        self.addUIInterruptionMonitorWithDescription("“GrantPermissionScriptSample” Would Like to Access Your Photos") { (interruptingElement) -> Bool in
            interruptingElement.buttons["OK"].tap()
            return true
        }
        
        app.buttons["Access Photos"].tap()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { 
            XCTAssertTrue(app.staticTexts["Photos granted"].exists)
            photosExpect.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(2) { (error) in
            if (error != nil) {
                print(error)
            }
        }
    }
    
    func testAddressAccess()  {
        let app = XCUIApplication()
        
        let addressBookExpect = expectationWithDescription("Address Book granted exists")
        
        self.addUIInterruptionMonitorWithDescription("“GrantPermissionScriptSample” Would Like to Access Your Contacts") { (interruptingElement) -> Bool in
            interruptingElement.buttons["OK"].tap()
            return true
        }
        
        app.buttons["Access Address Book"].tap()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            XCTAssertTrue(app.staticTexts["Address granted"].exists)
            addressBookExpect.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(2) { (error) in
            if (error != nil) {
                print(error)
            }
        }
    }
    
    func testCalendarAccess()  {
        let app = XCUIApplication()
        
        let addressBookExpect = expectationWithDescription("Calendar Event granted exists")
        
        self.addUIInterruptionMonitorWithDescription("“GrantPermissionScriptSample” Would Like to Access Your Calendar") { (interruptingElement) -> Bool in
            interruptingElement.buttons["OK"].tap()
            return true
        }
        
        app.buttons["Access Calendar"].tap()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            XCTAssertTrue(app.staticTexts["Calendar granted"].exists)
            addressBookExpect.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(2) { (error) in
            if (error != nil) {
                print(error)
            }
        }
    }
    
    func testHomeKitAccess()  {
        let app = XCUIApplication()
        
        let addressBookExpect = expectationWithDescription("Homekit granted exists")
        
        self.addUIInterruptionMonitorWithDescription("“GrantPermissionScriptSample” Would Like to Access Your Home Data") { (interruptingElement) -> Bool in
            interruptingElement.buttons["OK"].tap()
            return true
        }
        
        app.buttons["Access HomeKit"].tap()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            XCTAssertTrue(app.staticTexts["Homekit granted"].exists)
            addressBookExpect.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(2) { (error) in
            if (error != nil) {
                print(error)
            }
        }
    }
    
}
