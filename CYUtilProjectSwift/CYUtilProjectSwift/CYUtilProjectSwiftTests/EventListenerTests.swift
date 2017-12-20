//
//  EventListenerTests.swift
//  CYUtilProjectSwiftTests
//
//  Created by Jasper on 15/12/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import XCTest

@testable import CYUtilProjectSwift

class EventListenerTests: XCTestCase {
    
    var listener: CYUtilProjectSwift.EventListener!
    
    override func setUp() {
        super.setUp()
        
         listener = EventListener()
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testRegister() {
        let userInfoOuter = ["string": "test1"]
        listener!.register(closure: { (listener, event, userInfo) in
            
            XCTAssertEqual(event, "event_closure", "event_closure event not the same")
//            XCTAssertEqual(userInfo!["string"]!, userInfoOuter["string"]!, " event_closure handler user info failed")
            
        }, for: "event_closure")
        
        XCTAssertTrue(listener.canHandle(event: "event_closure"), "Cannot handle registered event_closure ")
        XCTAssertFalse(listener.canHandle(event: "fdfdfdfdsafsaf"),  "Can handle not registered fdfdfdfdsafsaf ")
//        listener.handle(event: "event_closure", userInfo: userInfoOuter)
    }
    
}
