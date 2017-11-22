//
//  CYQQUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/10/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYQQ.h"

#if CY_QQ_ENABLED
#import "CYQQ+Login.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "CYShareModel.h"

#import "TencentOpenApi/TencentOAuth.h"
#import "TencentOpenApi/QQApiInterface.h"

@interface CYQQ() <TencentSessionDelegate, QQApiInterfaceDelegate>

@property (nonatomic, strong, readwrite) TencentOAuth *oauth;

@end

@implementation CYQQ

NSString *const CYQQAPICtrlFlagKey = @"CYUtil.CYQQAPICtrlFlagKey";

#pragma mark - register
- (void)registerAppId:(NSString *)appId {
    [super registerAppId:appId];

    self.oauth = [[TencentOAuth alloc] initWithAppId:self.appId
                                         andDelegate:self];
}

#pragma mark - login delegate
- (void)tencentDidLogin {

#if CY_QQ_LOGIN_ENABLED
    self.loginInfo = [[CYLoginInfo alloc] init];
    self.loginInfo.qqOAuth = self.oauth;
    if (self.loginCallback) {
        self.loginCallback(0,
                           NSLocalizedString(@"Success", nil),
                           self.loginInfo);
        self.loginCallback = nil;
    }
#endif
}

- (void)tencentDidNotLogin:(BOOL)cancelled {

#if CY_QQ_LOGIN_ENABLED
    if (self.loginCallback) {
        self.loginCallback(-1,
                           NSLocalizedString(@"Cancelled", nil),
                           nil);
        self.loginCallback = nil;
    }
    self.loginInfo = nil;
#endif
}

- (void)tencentDidNotNetWork {

#if CY_QQ_LOGIN_ENABLED
    if (self.loginCallback) {
        self.loginCallback(-2,
                           NSLocalizedString(@"network error", nil),
                           nil);
        self.loginCallback = nil;
    }
    self.loginInfo = nil;
#endif
}

- (void)tencentDidLogout {

#if CY_QQ_LOGIN_ENABLED
    self.loginInfo = nil;
#endif
}

#pragma mark - share
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback {

    UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [self share:model fromViewController:viewController callback:callback];
}

- (void)share:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {

    // 获取model中指定的分享方式
    id flag = [model.userInfo objectForKey:CYQQAPICtrlFlagKey];
    if (flag && [flag isKindOfClass:[NSNumber class]]) {

        // 按userInfo中指定的分享方式分享
        [self share:model
                 to:[flag unsignedLongLongValue]
           callback:callback];
    } else {
        // 未指定分享方式，则让用户选择分享给好友，或者分享到朋友圈
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                         style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

                                                             if (callback) {
                                                                 callback(-1, @"User cancel");
                                                             }
                                                         }];
        [actionSheet addAction:cancel];

        UIAlertAction *session = [UIAlertAction actionWithTitle:NSLocalizedString(@"分享给QQ好友", nil)
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self shareToQQ:model
                                                                   callback:callback];
                                                        }];
        [actionSheet addAction:session];

        UIAlertAction *timeline = [UIAlertAction actionWithTitle:NSLocalizedString(@"分享到QQ空间", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self shareToQZone:model
                                                                       callback:callback];
                                                         }];
        [actionSheet addAction:timeline];

        [viewController presentViewController:actionSheet animated:YES completion:nil];
    }
}

- (void)shareToQQ:(CYShareModel *)model
         callback:(CYShareCallback)callback {

    [self share:model
             to:CYQQAPICtrlFlagQQShare
       callback:callback];
}

- (void)shareToQZone:(CYShareModel *)model
            callback:(CYShareCallback)callback {
    [self share:model
             to:CYQQAPICtrlFlagQZoneShareOnStart
       callback:callback];
}

- (void)share:(CYShareModel *)model
           to:(CYQQAPICtrlFlag)flag
     callback:(CYShareCallback)callback {
    if (!model.isValid) {
        if (callback) {
            callback(-1, @"The share model is invalid!!!");
        }
        return ;
    }

    QQApiObject *object = nil;
    switch (model.type) {
        case CYShareContenTypeText: {
            object = [QQApiTextObject objectWithText:model.content];
            break;
        }

        case CYShareContenTypeURL: {
            object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:model.url]
                                              title:model.title
                                        description:model.content
                                   previewImageData:model.thumbnail];
            break;
        }

        case CYShareContenTypeImage: {
            object = [QQApiImageObject objectWithData:model.data
                                     previewImageData:model.thumbnail
                                                title:model.title
                                          description:model.content];
            break;
        }

        default:
            break;
    }
    object.cflag = flag;

    SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:object];
    QQApiSendResultCode code = [QQApiInterface sendReq:request];

    self.shareCallback = callback;

    if (code != EQQAPISENDSUCESS
        && self.shareCallback) {

        self.shareCallback(code, nil);
        self.shareCallback = nil;
    }

}

#pragma mark - QQApiInterfaceDelegate
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req {
    
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp {
    
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        
        if (self.shareCallback) {
            
            self.shareCallback([resp.result integerValue], resp.errorDescription);
            self.shareCallback = nil;
        }
    }
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response {
    
}

#pragma mark - handle open url
// 以下几个方法需要在AppDelegate对应的方法中进行调用，并且必须实现这些方法

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [QQApiInterface handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [QQApiInterface handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

#pragma mark - api
+ (BOOL)openApp {
    
    return [QQApiInterface openQQ];
}

+ (BOOL)appInstalled {
    
    return [QQApiInterface isQQInstalled];
}

#pragma mark - sharedInstance
+ (instancetype)sharedInstance {
    
    static CYQQ *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        util = [[CYQQ alloc] init];
    });
    return util;
}

@end

#endif
