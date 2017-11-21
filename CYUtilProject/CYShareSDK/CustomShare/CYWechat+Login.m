//
//  CYWechat+Login.m
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYWechat+Login.h"

#if CY_WECHAT_ENABLED && CY_WECHAT_LOGIN_ENABLED

#import <objc/runtime.h>

#pragma mark - logininfo
// 登录信息增加微信元数据
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



#pragma mark - userinfo
// 用户信息增加微信元数据
@implementation CYUserInfo (Wechat)

static char CYShareSDK_CYUserInfo_wechatUserInfoKey;

@dynamic wechatUserInfo;

- (void)setWechatUserInfo:(NSDictionary *)wechatUserInfo{
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYUserInfo_wechatUserInfoKey,
                             wechatUserInfo,
                             OBJC_ASSOCIATION_RETAIN);

    self.userId = wechatUserInfo[@"openid"];
    self.nickname = wechatUserInfo[@"nickname"];
    self.headImgUrl = wechatUserInfo[@"headimgurl"];
    self.gender = [wechatUserInfo[@"sex"] integerValue];
}

- (NSDictionary *)wechatUserInfo {
    return objc_getAssociatedObject(self, &CYShareSDK_CYUserInfo_wechatUserInfoKey);
}

@end



#pragma mark - login
@implementation CYWechat (Login)

#define CY_WECHAT_GET_ACCESS_TOKEN_URL   @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"
#define CY_WECHAT_REFRESH_ACCESS_TOKEN_URL @"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@"
#define CY_WECHAT_GET_USER_INFO_URL @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@"

#define CY_WECHAT_STATE         @"CYUtil.CYWechatState"

#pragma mark - login actions
- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
                    callback:(CYLoginCallback)callback {
    return [self loginWithPermissions:permissions
                   fromViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController]
                             callback:callback];
}

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
          fromViewController:(UIViewController *)viewController
                    callback:(CYLoginCallback)callback {

    if (permissions.count == 0) {
        return NO;
    }

    //构造SendAuthReq结构体
    SendAuthReq* request =[[SendAuthReq alloc ] init];
    request.scope = [permissions componentsJoinedByString:@","];
    request.state = CY_WECHAT_STATE;
    //第三方向微信终端发送一个SendAuthReq消息结构
    BOOL result = [WXApi sendAuthReq:request
                      viewController:viewController
                            delegate:self];

    if (result) {

        self.loginCallback = callback;
    }
    return result;
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
                          callback:(CYGetUserInfoCallback)callback {

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
                                                                         CYUserInfo *userInfo = nil;
                                                                         if (data) {
                                                                             NSError *error = nil;
                                                                             NSDictionary *wechatResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                                             if (!error
                                                                                 && wechatResponse
                                                                                 && [wechatResponse isKindOfClass:[NSDictionary class]]) {

                                                                                 errorCode = [wechatResponse[@"errcode"] integerValue];
                                                                                 msg = wechatResponse[@"errmsg"];
                                                                                 if (errorCode == 0) {
                                                                                     userInfo = [[CYUserInfo alloc] init];
                                                                                     userInfo.wechatUserInfo = wechatResponse;
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

#endif
