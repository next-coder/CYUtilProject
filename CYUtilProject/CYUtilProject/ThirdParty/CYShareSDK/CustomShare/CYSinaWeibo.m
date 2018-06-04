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
            NSError *error = [NSError errorWithDomain:CYShareErrorDomain
                                                 code:CYShareErrorCodeInvalidParams
                                             userInfo:@{ @"msg": NSLocalizedString(@"参数错误", nil) }];
            callback(error);
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
        NSError *error = [NSError errorWithDomain:CYShareErrorDomain
                                             code:CYShareErrorCodeOpenAppFailed
                                         userInfo:@{ @"msg": NSLocalizedString(@"调用微博分享失败", nil) }];
        self.shareCallback(error);
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
        if (self.shareCallback) {
            self.shareCallback([self errorWithResponse:response]);
            self.shareCallback = nil;
        }
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
            self.loginCallback(loginInfo, [self errorWithResponse:response]);
            self.loginCallback = nil;
        }
#endif
    }
}

- (NSError *)errorWithResponse:(WBBaseResponse *)response {
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        // 成功状态下，直接返回nil
        return nil;
    }
    
    NSError *error = nil;
    switch (response.statusCode) {
        case WeiboSDKResponseStatusCodeUserCancel:
            error = [NSError errorWithDomain:CYShareErrorDomain
                                        code:CYShareErrorCodeUserCancel
                                    userInfo:@{ @"msg": NSLocalizedString(@"用户取消", nil), @"sourceError": [NSNumber numberWithInteger:response.statusCode] }];
            break;
            
        case WeiboSDKResponseStatusCodeSentFail:
            error = [NSError errorWithDomain:CYShareErrorDomain
                                        code:CYShareErrorCodeSentFail
                                    userInfo:@{ @"msg": NSLocalizedString(@"发送失败", nil), @"sourceError": [NSNumber numberWithInteger:response.statusCode] }];
            break;
            
        case WeiboSDKResponseStatusCodeAuthDeny:
            error = [NSError errorWithDomain:CYShareErrorDomain
                                        code:CYShareErrorCodeAuthDeny
                                    userInfo:@{ @"msg": NSLocalizedString(@"授权失败", nil), @"sourceError": [NSNumber numberWithInteger:response.statusCode] }];
            break;
            
        case WeiboSDKResponseStatusCodeShareInSDKFailed:
            error = [NSError errorWithDomain:CYShareErrorDomain
                                        code:CYShareErrorCodeCommon
                                    userInfo:@{ @"msg": NSLocalizedString(@"分享失败", nil), @"sourceError": response.userInfo ? : @"" }];
            break;
            
        case WeiboSDKResponseStatusCodeUnsupport:
            error = [NSError errorWithDomain:CYShareErrorDomain
                                        code:CYShareErrorCodeUnsupport
                                    userInfo:@{ @"msg": NSLocalizedString(@"不支持的接口", nil), @"sourceError": [NSNumber numberWithInteger:response.statusCode] }];
            break;
            
        default:
            error = [NSError errorWithDomain:CYShareErrorDomain
                                        code:CYShareErrorCodeCommon
                                    userInfo:@{ @"msg": NSLocalizedString(@"其他错误", nil), @"sourceError": [NSNumber numberWithInteger:response.statusCode] }];
            break;
    }
    return error;
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
