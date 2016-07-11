//
//  GrantPermissionScriptSampleTests.swift
//  GrantPermissionScriptSampleTests
//
//  Created by Nico Prananta on 7/11/16.
//  Copyright © 2016 DelightfulDev. All rights reserved.
//

import XCTest
@testable import GrantPermissionScriptSample
import AddressBook

class GrantPermissionScriptSampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchResult() {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController: ViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let fetchResult = viewController.getFetchResult()
        XCTAssertNotNil(fetchResult)
    }
    
    func testAddressBook()  {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController: ViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let a = viewController.extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, nil))
        XCTAssertNotNil(a)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
