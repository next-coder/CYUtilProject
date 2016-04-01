//
//  CYSinaWeiboShareUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/24/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYSinaWeiboUtil.h"

#import "WeiboSDK.h"

@interface CYSinaWeiboUtil () <WeiboSDKDelegate>

@property (nonatomic, copy) CYShareCallback shareCallback;

@property (nonatomic, strong, readonly) NSString *appBackUrl;

@end

@implementation CYSinaWeiboUtil

- (instancetype)init {
    
    if (self = [super init]) {
        
        [WeiboSDK registerApp:self.appKey];
        
#ifdef DEBUG
      
        // debug 模式
        [WeiboSDK enableDebugMode:YES];
        
#endif
        NSLog(@"");
    }
    return self;
}

- (void)shareWebWithTitle:(NSString *)title
              description:(NSString *)description
           thumbImageData:(NSData *)thumbImageData
                urlString:(NSString *)urlString
                 callback:(CYShareCallback)callback {
    
    WBWebpageObject *web = [WBWebpageObject object];
    web.webpageUrl = urlString;
    web.title = title;
    web.description = description;
    web.thumbnailData = thumbImageData;
    web.objectID = @"CYSinaWeiboUtil";
    
    WBMessageObject *message = [WBMessageObject message];
    message.mediaObject = web;
    message.text = description;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    BOOL result = [WeiboSDK sendRequest:request];
    
    self.shareCallback = callback;
    if (!result
        && self.shareCallback) {
        
        self.shareCallback(-1, NSLocalizedString(@"分享失败", nil));
    }
}

- (void)shareImageWithDescription:(NSString *)description
                        imageData:(NSData *)imageData
                         callback:(CYShareCallback)callback {
    
    WBImageObject *image = [WBImageObject object];
    image.imageData = imageData;
    
    WBMessageObject *message = [WBMessageObject message];
    message.imageObject = image;
    message.text = description;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    BOOL result = [WeiboSDK sendRequest:request];
    
    self.shareCallback = callback;
    if (!result
        && self.shareCallback) {
        
        self.shareCallback(-1, NSLocalizedString(@"分享失败", nil));
    }
}

- (void)shareText:(NSString *)text
         callback:(CYShareCallback)callback {
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = text;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    BOOL result = [WeiboSDK sendRequest:request];
    
    self.shareCallback = callback;
    if (!result
        && self.shareCallback) {
        
        self.shareCallback(-1, NSLocalizedString(@"分享失败", nil));
    }
}

#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        
        // 分享完成
        self.shareCallback(response.statusCode, nil);
    }
}

#pragma mark - handle open
- (BOOL)handleOpenURL:(NSURL *)url {
    
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark - static
+ (instancetype)sharedInstance {
    
    static CYSinaWeiboUtil *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[CYSinaWeiboUtil alloc] init];
    });
    return util;
}

+ (BOOL)appInstalled {
    
    return [WeiboSDK isWeiboAppInstalled];
}

+ (BOOL)openApp {
    
    return [WeiboSDK openWeiboApp];
}

@end
