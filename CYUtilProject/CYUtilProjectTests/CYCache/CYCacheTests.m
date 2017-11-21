//
//  CYCacheTests.m
//  CYUtilProject
//
//  Created by xn011644 on 18/08/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CYCache.h"
#import "CYImageDownloader.h"

@interface CYCacheTests : XCTestCase

@end

@implementation CYCacheTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testImageDownload {

    XCTestExpectation *imageDownloadExpectation = [self expectationWithDescription:@"download image"];

    [[CYImageDownloader defaultDownloader] startDownloadImageWithUrl:[NSURL URLWithString:@"http://image.xiaoniuapp.com/qgz/2017/6/shVJg2SNsOtWH3AAW8bSkTgo.png"] progress:nil completion:^(UIImage *image, NSError *error) {
        XCTAssertNil(error, @"Download failed with error : %@", error);
        XCTAssertNotNil(image, @"Image is nil");
        [imageDownloadExpectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:30 handler:^(NSError * _Nullable error) {

        XCTAssertNil(error);
    }];
}

@end
