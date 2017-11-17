//
//  CYWechatUtil.m
//  MoneyJar2
//
//  Created by XNKJ on 6/4/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYWechat.h"

#if CY_WECHAT_ENABLED

#import "CYWechat+Login.h"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "CYShareModel.h"

@interface CYWechat()

@property (nonatomic, copy) CYWechatPayCallback payCallback;

@end

@implementation CYWechat

NSString *const CYWechatSceneKey = @"CYUtil.CYWechatSceneKey";

#pragma mark - register
- (void)registerAppId:(NSString *)appId {
    [super registerAppId:appId];
    [WXApi registerApp:appId];
}

#pragma mark - share
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback {
    UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [self share:model fromViewController:viewController callback:callback];
}

- (void)share:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback {

    // 获取userInfo中指定的分享方式
    id scene = [model.userInfo objectForKey:CYWechatSceneKey];
    if (!scene
        || ![scene isKindOfClass:[NSNumber class]]) {

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

        UIAlertAction *session = [UIAlertAction actionWithTitle:NSLocalizedString(@"分享给微信好友", nil)
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self shareToSession:model
                                                                        callback:callback];
                                                        }];
        [actionSheet addAction:session];

        UIAlertAction *timeline = [UIAlertAction actionWithTitle:NSLocalizedString(@"分享到微信朋友圈", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self shareToTimeline:model
                                                                          callback:callback];
                                                         }];
        [actionSheet addAction:timeline];

        [viewController presentViewController:actionSheet animated:YES completion:nil];
    } else {

        // 在userInfo中指定了分享方式
        [self share:model
                 to:[scene intValue]
           callback:callback];
    }

}

- (void)shareToSession:(CYShareModel *)model
              callback:(CYShareCallback)callback {

    [self share:model
             to:CYWechatSceneSession
       callback:callback];
}

- (void)shareToTimeline:(CYShareModel *)model
               callback:(CYShareCallback)callback {

    [self share:model
             to:CYWechatSceneTimeline
       callback:callback];
}

- (void)share:(CYShareModel *)model
           to:(CYWechatScene)scene
     callback:(CYShareCallback)callback {

    if (![[self class] appInstalled]) {

        if (callback) {
            callback(-1, @"Wechat App not installed!!!");
        }
        return;
    }
    if (!model.isValid) {

        if (callback) {
            callback(-1, @"The share model is invalid!!!");
        }
        return;
    }

    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    request.scene = (int)scene;
    switch (model.type) {
        case CYShareContenTypeText: {
            request.bText = YES;
            request.text = model.content;
            break;
        }

        case CYShareContenTypeImage: {
            request.bText = NO;

            WXImageObject *imageObject = [WXImageObject object];
            if (model.data) {
                imageObject.imageData = model.data;
            } else {
                imageObject.imageUrl = model.url;
            }

            WXMediaMessage *message = [[WXMediaMessage alloc] init];
            message.title = model.title;
            message.description = model.content;
            message.thumbData = model.thumbnail;
            message.mediaObject = imageObject;

            request.message = message;
            break;
        }

        case CYShareContenTypeURL: {
            request.bText = NO;

            WXWebpageObject *webpageObject = [WXWebpageObject object];
            webpageObject.webpageUrl = model.url;

            WXMediaMessage *message = [[WXMediaMessage alloc] init];
            message.title = model.title;
            message.description = model.content;
            message.thumbData = model.thumbnail;
            message.mediaObject = webpageObject;

            request.message = message;
            break;
        }
    }

    [WXApi sendReq:request];
    self.shareCallback = callback;
}

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req {
    
    
}

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {

#if CY_WECHAT_LOGIN_ENABLED
        // 登录回调
        SendAuthResp *response = (SendAuthResp *)resp;
        NSString *wechatCode = response.code;
        if (wechatCode
            && wechatCode.length > 0) {
            // 登录成功，获取accessToken
            [self getAccessTokenWithCode:wechatCode
                                callback:self.loginCallback];
        } else if (self.loginCallback) {
            // 登录失败
            self.loginCallback(response.errCode,
                               response.errStr,
                               nil);
        }
#endif
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // 分享回调
        if (self.shareCallback) {

            self.shareCallback((NSInteger)resp.errCode, resp.errStr);
            self.shareCallback = nil;
        }
    } else if ([resp isKindOfClass:[PayResp class]]) {

#if CY_WECHAT_PAY_ENABLED
        // 微信支付回调
        if (self.payCallback) {

            PayResp *response = (PayResp *)resp;
            self.payCallback(response.errCode, response.errStr, response.returnKey);
            self.payCallback = nil;
        }
    }
#endif
}

#pragma mark - handle open url
// 以下几个方法需要在AppDelegate对应的方法中进行调用，并且必须实现这些方法

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - api
+ (BOOL)openApp {
    
    return [WXApi openWXApp];
}

+ (BOOL)appInstalled {
    
    return [WXApi isWXAppInstalled];
}

#pragma mark - static single
+ (instancetype)sharedInstance {
    
    static CYWechat *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[CYWechat alloc] init];
    });
    return util;
}

@end

#pragma mark - pay
@interface CYWechatPayInfo ()

- (PayReq *)toPayReq;

@end

@implementation CYWechat (Pay)

- (void)payWithInfo:(CYWechatPayInfo *)payInfo
           callback:(CYWechatPayCallback)callback {
    self.payCallback = callback;
    PayReq *req = payInfo.toPayReq;
    [WXApi sendReq:req];
}

- (void)payWithInfoDictionary:(NSDictionary *)payInfoDic
                     callback:(CYWechatPayCallback)callback {
    [self payWithInfo:[[CYWechatPayInfo alloc] initWithDictionary:payInfoDic]
             callback:callback];
}

@end

@implementation CYWechatPayInfo

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {

        if (dic
            && [dic isKindOfClass:[NSDictionary class]]
            && dic.count > 0) {
            _partnerId = dic[@"partnerId"];
            _prepayId = dic[@"prepayId"];
            _package = dic[@"package"];
            _nonceStr = dic[@"nonceStr"];
            _sign = dic[@"sign"];

            _timeStamp = (UInt32)[dic[@"timeStamp"] unsignedIntegerValue];
        }
    }
    return self;
}

- (PayReq *)toPayReq {
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = self.partnerId;
    req.prepayId = self.prepayId;
    req.package = self.package;
    req.nonceStr = self.nonceStr;
    req.sign = self.sign;
    req.timeStamp = self.timeStamp;
    return req;
}

@end


#endif
