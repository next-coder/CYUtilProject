//
//  CYSinaWeiboShareUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/24/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYSinaWeibo.h"

#if CY_SHARE_SINA_WEIBO_ENABLED
#import "CYShareModel.h"

#import "WeiboSDK.h"

@interface CYSinaWeiboLoginInfo()

+ (instancetype)loginInfoWithResponse:(WBAuthorizeResponse *)response;

@end

@interface CYSinaWeibo () <WeiboSDKDelegate>

@property (nonatomic, copy) CYSinaWeiboLoginCallback loginCallback;

@property (nonatomic, strong, readwrite) CYSinaWeiboLoginInfo *loginInfo;

@end

@implementation CYSinaWeibo

#pragma mark - register
//// 微博的appId是微博开放平台第三方应用appKey
//- (void)registerAppId:(NSString *)appId {
//    [super registerAppId:appId];
//
//    [WeiboSDK registerApp:appId];
//}

- (void)registerAppKey:(NSString *)appKey {
    [super registerAppKey:appKey];

    [WeiboSDK registerApp:appKey];
}

#pragma mark - login
//- (void)loginFrom:(UIViewController *)viewController
//         callback:(CYThirdPartyLoginCallback)callback {
//
//    WBAuthorizeRequest *request = [[WBAuthorizeRequest alloc] init];
//    request.redirectURI = @"http://";
//    request.scope = @"";
//    request.shouldShowWebViewForAuthIfCannotSSO = YES;
//
//    [WeiboSDK sendRequest:request];
//}

#pragma mark - SinaWeibo share
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback {
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
        self.shareCallback(-1, NSLocalizedString(@"分享失败", nil));
        self.shareCallback = nil;
    }
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
        // 登录完成
        CYSinaWeiboLoginInfo *loginInfo = [CYSinaWeiboLoginInfo loginInfoWithResponse:(WBAuthorizeResponse *)response];
        self.loginInfo = loginInfo;
        if (self.loginCallback) {
            self.loginCallback(response.statusCode, nil, loginInfo);
            self.loginCallback = nil;
        }
    }
}

#pragma mark - handle open
- (BOOL)handleOpenURL:(NSURL *)url {
    
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark - static
+ (instancetype)sharedInstance {
    
    static CYSinaWeibo *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[CYSinaWeibo alloc] init];
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

#pragma mark - login
@implementation CYSinaWeibo (Login)

@dynamic loginInfo;

- (void)loginWithScope:(NSString *)scope
           redirectURI:(NSString *)redirectURI
              callback:(CYSinaWeiboLoginCallback)callback {

    self.loginCallback = callback;

    WBAuthorizeRequest *request = [[WBAuthorizeRequest alloc] init];
    request.scope = scope;
    request.redirectURI = redirectURI;
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

//- (void)loginCompleteWithResponse:(WBAuthorizeResponse *)response {
//
//}

@end



@implementation CYSinaWeiboLoginInfo

+ (instancetype)loginInfoWithResponse:(WBAuthorizeResponse *)response {
    if (response
        && response.statusCode == WeiboSDKResponseStatusCodeSuccess) {

        CYSinaWeiboLoginInfo *loginInfo = [[CYSinaWeiboLoginInfo alloc] init];
        loginInfo.userId = response.userID;
        loginInfo.accessToken = response.accessToken;
        loginInfo.expirationDate = response.expirationDate;
        loginInfo.refreshToken = response.refreshToken;
        return loginInfo;
    }
    return nil;
}

@end

#endif
