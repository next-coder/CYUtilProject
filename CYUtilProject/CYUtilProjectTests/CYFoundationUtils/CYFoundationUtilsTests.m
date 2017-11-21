//
//  CYFoundationUtilsTests.m
//  CYUtilProject
//
//  Created by xn011644 on 18/08/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSArray+CYJson.h"
#import "NSDictionary+CYJson.h"
#import "NSDictionary+CYSecureValue.h"
#import "NSString+CYUtils.h"
#import "NSDate+CYUtils.h"

@interface CYFoundationUtilsTests : XCTestCase

@property (nonatomic, strong) NSString *jsonDicString;
@property (nonatomic, strong) NSDictionary *jsonDictionary;
@property (nonatomic, strong) NSString *jsonDicFilePath;

@property (nonatomic, strong) NSString *jsonArrayString;
@property (nonatomic, strong) NSArray *jsonArray;
@property (nonatomic, strong) NSString *jsonArrayFilePath;

@end

@implementation CYFoundationUtilsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // initialize test params
    self.jsonDicString = @"{\"id\":\"1234554321\",\"name\":\"Huang\"}";
    self.jsonDictionary = @{ @"id": @"1234554321", @"name": @"Huang" };
    self.jsonDicFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"jsonDicFile"];

    self.jsonArrayString = @"[\"1234554321\",\"Huang\"]";
    self.jsonArray = @[ @"1234554321", @"Huang" ];
    self.jsonArrayFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"jsonArrayFile"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJsonDictionary {
    NSDictionary *jsonDic = [NSDictionary cy_dictionaryFromJsonString:self.jsonDicString];
    XCTAssertEqualObjects(jsonDic[@"id"], @"1234554321", @"Json String to Dictionary Failed");
    XCTAssertEqualObjects(jsonDic[@"name"], @"Huang", @"Json String to Dictionary Failed");

    NSString *jsonString = [self.jsonDictionary cy_jsonString];
    XCTAssertEqualObjects(jsonString, self.jsonDicString, @"Dic to Json String failed");
}

- (void)testJsonDictionaryFile {

    NSError *error = nil;
    BOOL result = [self.jsonDictionary cy_writeToFileAsJson:self.jsonDicFilePath
                                                automically:YES
                                                      error:&error];
    XCTAssertNil(error, @"Write to File Failed: %@", error);
    XCTAssertTrue(result, @"Write to File Failed");

    error = nil;
    NSString *jsonString = [NSString stringWithContentsOfFile:self.jsonDicFilePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    XCTAssertNil(error, @"Read Json Dictionary File Failed: %@", error);
    XCTAssertNotNil(jsonString, @"Read Json Dictionary File Failed, Json String is nil");

    NSDictionary *jsonDic = [NSDictionary cy_dictionaryFromJsonString:jsonString];
    XCTAssertEqualObjects(jsonDic[@"id"], @"1234554321", @"Json String to Dictionary Failed");
    XCTAssertEqualObjects(jsonDic[@"name"], @"Huang", @"Json String to Dictionary Failed");
}

- (void)testJsonArray {
    NSArray *jsonArray = [NSArray cy_arrayFromJsonString:self.jsonArrayString];
    XCTAssertEqualObjects(jsonArray[0], @"1234554321", @"Json String to Array Failed");
    XCTAssertEqualObjects(jsonArray[1], @"Huang", @"Json String to Array Failed");

    NSString *jsonString = [self.jsonArray cy_jsonString];
    XCTAssertEqualObjects(jsonString, self.jsonArrayString, @"Array to Json String Failed");
}

- (void)testJsonArrayFile {

    NSError *error = nil;
    BOOL result = [self.jsonArray cy_writeToFileAsJson:self.jsonArrayFilePath
                                           automically:YES
                                                 error:&error];
    XCTAssertNil(error, @"Write to File Failed: %@", error);
    XCTAssertTrue(result, @"Write to File Failed");

    error = nil;
    NSString *jsonString = [NSString stringWithContentsOfFile:self.jsonArrayFilePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    XCTAssertNil(error, @"Read Json Dictionary File Failed: %@", error);
    XCTAssertNotNil(jsonString, @"Read Json Dictionary File Failed, Json String is nil");

    NSArray *jsonArray = [NSArray cy_arrayFromJsonString:self.jsonArrayString];
    XCTAssertEqualObjects(jsonArray[0], @"1234554321", @"Json String to Array Failed");
    XCTAssertEqualObjects(jsonArray[1], @"Huang", @"Json String to Array Failed");
}

@end
