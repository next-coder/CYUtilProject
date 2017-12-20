//
//  CYSinaWeiboShareUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/24/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYSinaWeibo.h"

#if CY_SINA_WEIBO_ENABLED

#import "CYSinaWeibo+Login.h"
#import "CYShareModel.h"

#import "WeiboSDK.h"

@interface CYSinaWeibo () <WeiboSDKDelegate>

@end

@implementation CYSinaWeibo

#pragma mark - register
- (void)registerAppKey:(NSString *)appKey {
    [super registerAppKey:appKey];

    [WeiboSDK registerApp:appKey];
}

#pragma mark - SinaWeibo share
- (void)share:(CYShareModel *)model callback:(CYShareCallback)callback {
    if (!model.isValid) {
        if (callback) {
            callback(-1, @"The share model is invalid!!!");
        }
        return ;
    }

    WBMessageObject *message = [[WBMessageObject alloc] init];
    message.text = model.content;
    switch (model.type) {
        case CYShareContenTypeText: {
            break;
        }

        case CYShareContenTypeURL: {
            WBWebpageObject *webpageObject = [WBWebpageObject object];
            webpageObject.webpageUrl = model.url;
            webpageObject.title = model.title;
            webpageObject.description = model.content;
            webpageObject.thumbnailData = model.thumbnail;
            webpageObject.objectID = @"CYSinaWeiboUtil";

            message.mediaObject = webpageObject;
            break;
        }

        case CYShareContenTypeImage: {
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = model.data;

            message.imageObject = imageObject;
            break;
        }

        default:
            break;
    }

    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    BOOL result = [WeiboSDK sendRequest:request];

    self.shareCallback = callback;
    if (!result
        && self.shareCallback) {
        self.shareCallback(-1, NSLocalizedString(@"Failed", nil));
        self.shareCallback = nil;
    }
}

- (void)share:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {
    [self share:model callback:callback];
}

#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        
        // 分享完成
        self.shareCallback(response.statusCode, nil);
        self.shareCallback = nil;
    } else if ([response isKindOfClass:[WBAuthorizeResponse class]]) {

#if CY_SINA_WEIBO_LOGIN_ENABLED
        // 登录完成
        CYLoginInfo *loginInfo = nil;
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            loginInfo = [[CYLoginInfo alloc] init];
            loginInfo.sinaWeiboAuthorizeResponse = (WBAuthorizeResponse *)response;
            self.loginInfo = loginInfo;
        }
        if (self.loginCallback) {
            self.loginCallback(response.statusCode,
                               nil,
                               loginInfo);
            self.loginCallback = nil;
        }
#endif
    }
}

#pragma mark - handle open url
// 以下几个方法需要在AppDelegate对应的方法中进行调用，并且必须实现这些方法
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark - static
+ (instancetype)sharedInstance {
    
    static CYSinaWeibo *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[CYSinaWeibo alloc] init];
        // set default redirect uri
        [util registerRedirectURI:@"http://"];
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

#endif
