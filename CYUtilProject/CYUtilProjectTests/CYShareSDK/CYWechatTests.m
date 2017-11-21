//
//  CYWechatTests.m
//  CYUtilProjectTests
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CYShare.h"

@interface CYWechatTests : XCTestCase

@property (nonatomic, strong) CYShareModel *textModel;
@property (nonatomic, strong) CYShareModel *urlModel;
@property (nonatomic, strong) CYShareModel *imageModel;

@end

@implementation CYWechatTests

- (void)setUp {
    [super setUp];

    [CYShare registerWechatAppId:@"wx891f8f3380cba5e9"];
    [CYShare registerQQAppId:@"1104237169"];
    [CYShare registerWeiboAppKey:@"3180958896"];

    self.textModel = [CYShareModel textModelWithContent:@"Share Test"];

    NSString *thumbnailPath = [[NSBundle mainBundle] pathForResource:@"logo40" ofType:@"png"];
    NSData *thumbnail = [NSData dataWithContentsOfFile:thumbnailPath];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"share_image" ofType:@"jpg"];
    NSData *image = [NSData dataWithContentsOfFile:imagePath];
    self.urlModel = [CYShareModel urlModelWithTitle:@"Share Title"
                                            content:@"Share Content"
                                          thumbnail:thumbnail
                                                url:@"https://www.qguanzi.com"];
    self.imageModel = [CYShareModel imageModelWithTitle:@"Share title"
                                                content:@"Share content"
                                              thumbnail:thumbnail
                                                   data:image];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWechatShare {
    // text share
    XCTestExpectation *e1 = [self expectationWithDescription:@"Text Session Share"];
    [CYShare shareToWechat:self.textModel scene:CYWechatSceneSession callback:^(NSInteger code, NSString *msg) {
        XCTAssertEqual(code, 0, @"Share Failed");
        [e1 fulfill];
    }];
    [self waitForExpectations:@[ e1 ] timeout:1000];

    XCTestExpectation *e2 = [self expectationWithDescription:@"Text Timeline Share"];
    [CYShare shareToWechat:self.textModel scene:CYWechatSceneTimeline callback:^(NSInteger code, NSString *msg) {
        XCTAssertEqual(code, 0, @"Share Failed");
        [e2 fulfill];
    }];
    [self waitForExpectations:@[ e2 ] timeout:1000];

    // url share
    XCTestExpectation *e3 = [self expectationWithDescription:@"Text Timeline Share"];
    [CYShare shareToWechat:self.urlModel scene:CYWechatSceneSession callback:^(NSInteger code, NSString *msg) {
        XCTAssertEqual(code, 0, @"Share Failed");
        [e3 fulfill];
    }];
    [self waitForExpectations:@[ e3 ] timeout:1000];

    XCTestExpectation *e4 = [self expectationWithDescription:@"Text Timeline Share"];
    [CYShare shareToWechat:self.urlModel scene:CYWechatSceneTimeline callback:^(NSInteger code, NSString *msg) {
        XCTAssertEqual(code, 0, @"Share Failed");
        [e4 fulfill];
    }];
    [self waitForExpectations:@[ e4 ] timeout:1000];

    // image share
    XCTestExpectation *e5 = [self expectationWithDescription:@"Text Timeline Share"];
    [CYShare shareToWechat:self.imageModel scene:CYWechatSceneSession callback:^(NSInteger code, NSString *msg) {
        XCTAssertEqual(code, 0, @"Share Failed");
        [e5 fulfill];
    }];
    [self waitForExpectations:@[ e5 ] timeout:1000];

    XCTestExpectation *e6 = [self expectationWithDescription:@"Text Timeline Share"];
    [CYShare shareToWechat:self.imageModel scene:CYWechatSceneTimeline callback:^(NSInteger code, NSString *msg) {
        XCTAssertEqual(code, 0, @"Share Failed");
        [e6 fulfill];
    }];
    [self waitForExpectations:@[ e6 ] timeout:1000];

    // common
    XCTestExpectation *e7 = [self expectationWithDescription:@"Text Timeline Share"];
    self.textModel.userInfo = @{ CYWechatSceneKey: @0 };
    [CYShare shareToWeibo:self.textModel callback:^(NSInteger code, NSString *msg) {
        XCTAssertEqual(code, 0, @"Share Failed");
        [e7 fulfill];
    }];
    [self waitForExpectations:@[ e7 ] timeout:1000];

    XCTestExpectation *e8 = [self expectationWithDescription:@"Text Timeline Share"];
    self.imageModel.userInfo = @{ CYWechatSceneKey: @1 };
    [CYShare shareToWeibo:self.imageModel callback:^(NSInteger code, NSString *msg) {
        XCTAssertEqual(code, 0, @"Share Failed");
        [e8 fulfill];
    }];
    [self waitForExpectations:@[ e8 ] timeout:1000];

    XCTestExpectation *e9 = [self expectationWithDescription:@"Text Timeline Share"];
    [CYShare shareToWechat:self.urlModel fromViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController] callback:^(NSInteger code, NSString *msg) {
        XCTAssertEqual(code, 0, @"Share Failed");
        [e9 fulfill];
    }];
    [self waitForExpectations:@[ e9 ] timeout:1000];
}

- (void)testWechatLogin {
    
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
