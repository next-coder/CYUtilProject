//
//  XNWechatUtil.m
//  MoneyJar2
//
//  Created by XNKJ on 6/4/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYWechat.h"

#if CY_SHARE_WECHAT_ENABLED

#import <UIKit/UIKit.h>
#import "CYShareModel.h"

#import "WXApi.h"

//#define CY_WECHAT_GET_ACCESS_TOKEN_URL   @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"

#define CY_WECHAT_STATE         @"CYUtil.CYWechatState"

@interface CYWechat () <WXApiDelegate>

//@property (nonatomic, copy) CYThirdPartyLoginCallback loginCallback;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation CYWechat

NSString *const CYWechatSceneKey = @"CYUtil.CYWechatSceneKey";

- (NSOperationQueue *)operationQueue {
    
    if (!_operationQueue) {
        
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

#pragma mark - register
- (void)registerWithAppId:(NSString *)appId {
    [super registerWithAppId:appId];
    [WXApi registerApp:appId];
}

#pragma mark - Wechat login
//- (void)loginFrom:(UIViewController *)from
//         callback:(CYThirdPartyLoginCallback)callback {
//
//    //构造SendAuthReq结构体
//    SendAuthReq* request =[[SendAuthReq alloc ] init];
//    request.scope = @"snsapi_userinfo" ;
//    request.state = CY_WECHAT_STATE;
//    //第三方向微信终端发送一个SendAuthReq消息结构
//    [WXApi sendAuthReq:request viewController:from delegate:self];
//
//    self.loginCallback = callback;
//}
//
//- (void)getWechatAccessTokenWithCode:(NSString *)code {
//
//    NSString *urlString = [NSString stringWithFormat:CY_WECHAT_GET_ACCESS_TOKEN_URL, [[self class] appId], [[self class] appKey], code];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
//                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
//                                         timeoutInterval:30.f];
//
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:self.operationQueue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//
//                               // 回到主线程，这个是通过子线程回调的
//                               dispatch_async(dispatch_get_main_queue(), ^{
//
//                                   if (data) {
//
//                                       NSError *error = nil;
//                                       NSDictionary *wechatResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//                                       if (!error
//                                           && wechatResponse
//                                           && [wechatResponse isKindOfClass:[NSDictionary class]]) {
//
//                                           NSInteger  errorCode = [[wechatResponse objectForKey:@"errcode"] integerValue];
//
//                                           if (errorCode != 0) {
//
//                                               if (self.loginCallback) {
//
//                                                   self.loginCallback(errorCode,
//                                                                      [wechatResponse objectForKey:@"errmsg"],
//                                                                      wechatResponse);
//                                               }
//                                           } else {
//
//                                               if (self.loginCallback) {
//
//                                                   self.loginCallback(0,
//                                                                      @"",
//                                                                      wechatResponse);
//                                               }
//                                           }
//                                       } else {
//
//                                           if (self.loginCallback) {
//
//                                               self.loginCallback(error.code, [error.userInfo objectForKey:@"msg"], @{});
//                                           }
//                                       }
//                                   }
//                               });
//
//                           }];
//
//}

#pragma mark - share
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback {

    id scene = [model.userInfo objectForKey:CYWechatSceneKey];
    if (!scene
        || ![scene isKindOfClass:[NSNumber class]]) {

        [self share:model
presentActionSheetFrom:[[[UIApplication sharedApplication] keyWindow] rootViewController]
           callback:callback];
    } else {

        [self share:model
                 to:[scene intValue]
           callback:callback];
    }
}

- (void)share:(CYShareModel *)model
presentActionSheetFrom:(UIViewController *)viewController
     callback:(CYShareCallback)callback {

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
        case XNShareContenTypeText: {
            request.bText = YES;
            request.text = model.content;
            break;
        }

        case XNShareContenTypeImage: {
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

        case XNShareContenTypeURL: {
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
        
//        // 登录回调
//        [self receiveAuthResponse:(SendAuthResp *)resp];
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        
        // 分享回调
        NSInteger errorCode = resp.errCode;
        if (errorCode == WXErrCodeUserCancel) {
            
            errorCode = 2;
        } else if (errorCode != 0) {
            
            errorCode = 1;
        }
        if (self.shareCallback) {
            
            self.shareCallback(errorCode, resp.errStr);
            self.shareCallback = nil;
        }
    }
}

//// 登录回调
//- (void)receiveAuthResponse:(SendAuthResp *)response {
//
//    NSString *wechatCode = response.code;
//    NSInteger errorCode = response.errCode;
//
//    if (errorCode == 0) {
//
//        [self getWechatAccessTokenWithCode:wechatCode];
//    } else {
//
//        if (errorCode == WXErrCodeUserCancel) {
//
//            errorCode = 2;
//        } else {
//
//            errorCode = 1;
//        }
//
//        if (self.loginCallback) {
//
//            self.loginCallback(errorCode, response.errStr, nil);
//            self.loginCallback = nil;
//        }
//    }
//}

#pragma mark - handle open url
- (BOOL)handleOpenURL:(NSURL *)URL {
    
    return [WXApi handleOpenURL:URL delegate:self];
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

#endif
