//
//  CYWechatUtil.m
//  MoneyJar2
//
//  Created by XNKJ on 6/4/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYWechat.h"

#if CY_SHARE_WECHAT_ENABLED

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "CYShareModel.h"

#import "WXApi.h"

#define CY_WECHAT_STATE         @"CYUtil.CYWechatState"

@interface CYWechat() <WXApiDelegate>

//@property (nonatomic, copy) CYWechatLoginCallback loginCallback;
@property (nonatomic, copy) CYWechatPayCallback payCallback;
//@property (nonatomic, copy) CYWechatAccessTokenCallback accessTokenCallback;
//@property (nonatomic, copy) CYWechatUserInfoCallback userInfoCallback;

//@property (nonatomic, strong, readwrite) CYWechatAccessToken *accessToken;
@property (nonatomic, strong, readwrite) CYWechatUserInfo *userInfo;

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
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // 分享回调
        if (self.shareCallback) {

            self.shareCallback((NSInteger)resp.errCode, resp.errStr);
            self.shareCallback = nil;
        }
    } else if ([resp isKindOfClass:[PayResp class]]) {
        // 微信支付回调
        if (self.payCallback) {

            PayResp *response = (PayResp *)resp;
            self.payCallback(response.errCode, response.errStr, response.returnKey);
            self.payCallback = nil;
        }
    }
}

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

#pragma mark - wechat login
//@interface CYWechatAccessToken()
//
//- (instancetype)initWithDictionary:(NSDictionary *)dic;
//
//@end

@interface CYWechatUserInfo()

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@implementation CYWechat (Login)

#define CY_WECHAT_GET_ACCESS_TOKEN_URL   @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"
#define CY_WECHAT_REFRESH_ACCESS_TOKEN_URL @"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@"
#define CY_WECHAT_GET_USER_INFO_URL @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@"

//@dynamic accessToken;
@dynamic userInfo;

/**
 *  微信登陆
 *
 *  @param from     没有安装微信时，用于web登陆present
 *  @param callback 登陆回调
 */
- (void)loginFrom:(UIViewController *)from
         callback:(CYLoginCallback)callback {

    //构造SendAuthReq结构体
    SendAuthReq* request =[[SendAuthReq alloc ] init];
    request.scope = @"snsapi_userinfo" ;
    request.state = CY_WECHAT_STATE;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendAuthReq:request viewController:from delegate:self];

    self.loginCallback = callback;
}

// 获取微信access token
- (void)getAccessTokenWithCode:(NSString *)code callback:(CYLoginCallback)callback {

    NSString *urlString = [NSString stringWithFormat:CY_WECHAT_GET_ACCESS_TOKEN_URL, self.appId, self.appKey, code];
    [self accessTokenWithURL:urlString callback:callback];
}

- (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken
                                  callback:(CYLoginCallback)callback {

    NSString *urlString = [NSString stringWithFormat:CY_WECHAT_REFRESH_ACCESS_TOKEN_URL, self.appId, refreshToken];
    [self accessTokenWithURL:urlString callback:callback];
}

- (void)accessTokenWithURL:(NSString *)urlString callback:(CYLoginCallback)callback {

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:30.f];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                     // 回到主线程，这个是通过子线程回调的
                                                                     dispatch_async(dispatch_get_main_queue(), ^{

                                                                         NSInteger errorCode = error.code;
                                                                         NSString *msg = [error.userInfo objectForKey:@"msg"];
                                                                         CYLoginInfo *loginInfo = nil;
                                                                         if (data) {
                                                                             NSError *error = nil;
                                                                             NSDictionary *wechatResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                                             if (!error
                                                                                 && wechatResponse
                                                                                 && [wechatResponse isKindOfClass:[NSDictionary class]]) {

                                                                                 errorCode = [wechatResponse[@"errcode"] integerValue];
                                                                                 msg = wechatResponse[@"errmsg"];
                                                                                 if (errorCode == 0) {
                                                                                     loginInfo = [[CYLoginInfo alloc] init];
                                                                                     loginInfo.wechatAccessTokenInfo = wechatResponse;
                                                                                     self.loginInfo = loginInfo;
                                                                                 }
                                                                             } else {

                                                                                 errorCode = error.code;
                                                                                 msg = [error.userInfo objectForKey:@"msg"];
                                                                             }
                                                                         }
                                                                         if (callback) {
                                                                             callback(errorCode, msg, loginInfo);
                                                                         }
                                                                     });
                                                                 }];
    [task resume];
}

- (void)getUserInfoWithAccessToken:(NSString *)accessToken
                            openid:(NSString *)openid
                          callback:(CYWechatUserInfoCallback)callback {
    //    NSAssert(accessToken != nil, @"Access token should not be nil");
    //    NSAssert(openid != nil, @"Openid should not be nil");

    NSString *urlString = [NSString stringWithFormat:CY_WECHAT_GET_USER_INFO_URL, accessToken, openid];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:30.f];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                     // 回到主线程，这个是通过子线程回调的
                                                                     dispatch_async(dispatch_get_main_queue(), ^{

                                                                         NSInteger errorCode = error.code;
                                                                         NSString *msg = [error.userInfo objectForKey:@"msg"];
                                                                         CYWechatUserInfo *userInfo = nil;
                                                                         if (data) {
                                                                             NSError *error = nil;
                                                                             NSDictionary *wechatResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                                             if (!error
                                                                                 && wechatResponse
                                                                                 && [wechatResponse isKindOfClass:[NSDictionary class]]) {

                                                                                 errorCode = [wechatResponse[@"errcode"] integerValue];
                                                                                 msg = wechatResponse[@"errmsg"];
                                                                                 if (errorCode == 0) {
                                                                                     userInfo = [[CYWechatUserInfo alloc] initWithDictionary:wechatResponse];
                                                                                     self.userInfo = userInfo;
                                                                                 }
                                                                             } else {
                                                                                 errorCode = error.code;
                                                                                 msg = [error.userInfo objectForKey:@"msg"];
                                                                             }
                                                                         }

                                                                         if (callback) {
                                                                             callback(errorCode, msg, userInfo);
                                                                         }
                                                                     });
                                                                 }];
    [task resume];
}

@end

//#pragma mark - wechat access token data
//@implementation CYWechatAccessToken
//
//- (instancetype)initWithDictionary:(NSDictionary *)dic {
//    if (self = [super init]) {
//
//        if (dic
//            && [dic isKindOfClass:[NSDictionary class]]
//            && dic.count > 0) {
//            self.accessToken = dic[@"access_token"];
//            self.expiresIn = [dic[@"expires_in"] doubleValue];
//            self.refreshToken = dic[@"refresh_token"];
//            self.openid = dic[@"openid"];
//            self.scope = dic[@"scope"];
//            self.unionid = dic[@"unionid"];
//        }
//    }
//    return self;
//}
//
//@end

@implementation CYLoginInfo (Wechat)

static char CYShareSDK_CYLoginInfo_wechatAccessTokenInfoKey;

@dynamic wechatAccessTokenInfo;

- (void)setWechatAccessTokenInfo:(NSDictionary *)wechatAccessTokenInfo {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYLoginInfo_wechatAccessTokenInfoKey,
                             wechatAccessTokenInfo,
                             OBJC_ASSOCIATION_RETAIN);

    self.accessToken = wechatAccessTokenInfo[@"access_token"];
    self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:[wechatAccessTokenInfo[@"expires_in"] doubleValue]];
    self.refreshToken = wechatAccessTokenInfo[@"refresh_token"];
    self.userId = wechatAccessTokenInfo[@"openid"];
}

- (NSDictionary *)wechatAccessTokenInfo {
    return objc_getAssociatedObject(self, &CYShareSDK_CYLoginInfo_wechatAccessTokenInfoKey);
}

@end

#pragma mark - wechat user info
/**
 *  微信用户信息
 */
@implementation CYWechatUserInfo

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {

        if (dic
            && [dic isKindOfClass:[NSDictionary class]]
            && dic.count > 0) {
            self.openid = dic[@"openid"];
            self.nickname = dic[@"nickname"];
            self.province = dic[@"province"];
            self.city = dic[@"city"];
            self.country = dic[@"country"];
            self.headimgurl = dic[@"headimgurl"];
            self.unionid = dic[@"unionid"];
            self.privilege = dic[@"privilege"];

            self.sex = [dic[@"sex"] integerValue];
        }
    }
    return self;
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

//- (void)payWithInfoJSON:(NSData *)jsonData
//               callback:(CYWechatPayCallback)callback {
//
//    NSError *error = nil;
//    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                            options:0
//                                                              error:&error];
//    if (!error) {
//
//        [self payWithInfo:[[CYWechatPayInfo alloc] initWithDictionary:jsonDic]
//                 callback:callback];
//    } else if (callback) {
//        callback(error.code, NSLocalizedString(@"JSONData is invalid", nil), nil);
//    }
//}

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
