//
//  DeviceAuthenticationTests.swift
//  CYUtilProjectSwiftTests
//
//  Created by xn011644 on 10/10/2017.
//  Copyright © 2017 Jasper. All rights reserved.
//

import XCTest
@testable import CYUtilProjectSwift

class DeviceAuthenticationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAvailable() {
        _ = DeviceAuthentication.biometricsAuthAvailable
        _ = DeviceAuthentication.biometricsAuthStatus
        _ = DeviceAuthentication.biometricsOrPasscodeAuthAvailable
        _ = DeviceAuthentication.biometricsOrPasscodeAuthStatus
    }

    func testAuth() {
        let expectaion1 = self.expectation(description: "指纹验证")
        DeviceAuthentication.authByBiometrics(localizedReason: "请验证您的指纹") { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error, "Some error occur while auth by biometrics: \(error?.localizedDescription ?? "")")
            expectaion1.fulfill()
        }
        self.wait(for: [expectaion1], timeout: 100)

        let expectaion2 = self.expectation(description: "指纹多按钮验证")
        DeviceAuthentication.authByBiometrics(localizedReason: "请验证您的指纹(多按钮)", localizedCancelTitle: "取消1", localizedFallbackTitle: "确定") { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error, "Some error occur while auth by biometrics(fallback button): \(error?.localizedDescription ?? "")")
            expectaion2.fulfill()
        }
        self.wait(for: [expectaion2], timeout: 100)

        let expectaion3 = self.expectation(description: "指纹或密码验证")
        DeviceAuthentication.authByBiometricsOrPasscode(localizedReason: "请验证您的指纹或密码", completion: { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error, "Some error occur while auth by biometrics or passcode: \(error?.localizedDescription ?? "")")
            expectaion3.fulfill()
        })
        self.wait(for: [expectaion3], timeout: 100)

        let expectaion4 = self.expectation(description: "指纹或密码验证(多按钮)")
        DeviceAuthentication.authByBiometricsOrPasscode(localizedReason: "请验证您的指纹或密码", localizedCancelTitle: "取消1", localizedFallbackTitle: "确定") { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error, "Some error occur while auth by biometrics or passcode(fallback button): \(error?.localizedDescription ?? "")")
            expectaion4.fulfill()
        }
        self.wait(for: [expectaion4], timeout: 100)

    }
    
}
