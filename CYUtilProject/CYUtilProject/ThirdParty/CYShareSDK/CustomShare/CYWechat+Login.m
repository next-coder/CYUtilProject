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

NSString *const CYWechatLoginPermissionSNSApiBase = @"snsapi_userinfo";
NSString *const CYWechatLoginPermissionSNSApiUserInfo = @"snsapi_userinfo";

static char CYShareSDK_CYWechatLogin_ShouldGetAccessTokenKey;
static char CYShareSDK_CYWechatLogin_CodeCallbackKey;

@dynamic shouldGetAccessToken;
@dynamic codeCallback;

- (void)setShouldGetAccessToken:(BOOL)shouldGetAccessToken {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYWechatLogin_ShouldGetAccessTokenKey,
                             [NSNumber numberWithBool:shouldGetAccessToken],
                             OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)shouldGetAccessToken {
    return [objc_getAssociatedObject(self, &CYShareSDK_CYWechatLogin_ShouldGetAccessTokenKey) boolValue];
}

- (void)setCodeCallback:(CYWechatLoginCodeCallback)codeCallback {
    objc_setAssociatedObject(self,
                             &CYShareSDK_CYWechatLogin_CodeCallbackKey,
                             codeCallback,
                             OBJC_ASSOCIATION_COPY);
}

- (CYWechatLoginCodeCallback)codeCallback {
    return objc_getAssociatedObject(self, &CYShareSDK_CYWechatLogin_CodeCallbackKey);
}

#pragma mark - login actions
- (BOOL)loginWithCodeCallback:(CYWechatLoginCodeCallback)codeCallback {
    return [self loginWithPermissions:@[ CYWechatLoginPermissionSNSApiUserInfo ]
                   fromViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController]
                         codeCallback:codeCallback
                 shouldGetAccessToken:NO
                  accessTokenCallback:nil];
}

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
          fromViewController:(UIViewController *)viewController
                codeCallback:(CYWechatLoginCodeCallback)codeCallback
        shouldGetAccessToken:(BOOL)shouldGetAccessToken
         accessTokenCallback:(CYLoginCallback)accessTokenCallback {
    
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
        
        [self setCodeCallback:codeCallback];
        [self setShouldGetAccessToken:shouldGetAccessToken];
        [self setLoginCallback:accessTokenCallback];
    }
    return result;
}

- (BOOL)loginWithCallback:(CYLoginCallback)callback {
    return [self loginWithPermissions:@[ CYWechatLoginPermissionSNSApiUserInfo ] callback:callback];
}

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
                    callback:(CYLoginCallback)callback {
    return [self loginWithPermissions:permissions
                   fromViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController]
                             callback:callback];
}

- (BOOL)loginWithPermissions:(NSArray<NSString *> *)permissions
          fromViewController:(UIViewController *)viewController
                    callback:(CYLoginCallback)callback {

    return [self loginWithPermissions:permissions
                   fromViewController:viewController
                         codeCallback:nil
                 shouldGetAccessToken:YES
                  accessTokenCallback:callback];
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

                                                                         NSError *error = nil;
                                                                         CYLoginInfo *loginInfo = nil;
                                                                         if (data
                                                                             && data.length > 0) {
                                                                             NSDictionary *wechatResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                            options:0
                                                                                                                                              error:nil];
                                                                             if (wechatResponse
                                                                                 && [wechatResponse isKindOfClass:[NSDictionary class]]) {

                                                                                 NSInteger errorCode = [wechatResponse[@"errcode"] integerValue];
                                                                                 NSString *msg = wechatResponse[@"errmsg"];
                                                                                 if (errorCode == 0) {
                                                                                     // 获取AccessToken成功
                                                                                     loginInfo = [[CYLoginInfo alloc] init];
                                                                                     loginInfo.wechatAccessTokenInfo = wechatResponse;
                                                                                     self.loginInfo = loginInfo;
                                                                                 } else {
                                                                                     // 微信返回错误
                                                                                     error = [NSError errorWithDomain:CYShareErrorDomain
                                                                                                                 code:errorCode
                                                                                                             userInfo:@{ @"msg": msg ? : NSLocalizedString(@"获取用户token失败", nil) }];
                                                                                 }
                                                                             } else {
                                                                                 // 微信返回数据格式不对，无法解析
                                                                                 error = [NSError errorWithDomain:CYShareErrorDomain
                                                                                                             code:CYShareErrorCodeCommon
                                                                                                         userInfo:@{ @"msg": NSLocalizedString(@"微信返回数据格式错误", nil) }];
                                                                             }
                                                                         } else {
                                                                             // 网络请求错误
                                                                             error = [NSError errorWithDomain:CYShareErrorDomain
                                                                                                         code:CYShareErrorCodeCommon
                                                                                                     userInfo:@{ @"msg": NSLocalizedString(@"网络错误", nil) }];
                                                                         }
                                                                         if (callback) {
                                                                             callback(loginInfo, error);
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

                                                                         NSError *error = nil;
                                                                         CYUserInfo *userInfo = nil;
                                                                         if (data
                                                                             && data.length > 0) {
                                                                             NSDictionary *wechatResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                             if (wechatResponse
                                                                                 && [wechatResponse isKindOfClass:[NSDictionary class]]) {

                                                                                 NSInteger errorCode = [wechatResponse[@"errcode"] integerValue];
                                                                                 NSString *msg = wechatResponse[@"errmsg"];
                                                                                 if (errorCode == 0) {
                                                                                     userInfo = [[CYUserInfo alloc] init];
                                                                                     userInfo.wechatUserInfo = wechatResponse;
                                                                                     self.userInfo = userInfo;
                                                                                 } else {
                                                                                     // 微信返回错误
                                                                                     error = [NSError errorWithDomain:CYShareErrorDomain
                                                                                                                 code:errorCode
                                                                                                             userInfo:@{ @"msg": msg ? : NSLocalizedString(@"获取用户信息失败", nil) }];
                                                                                 }
                                                                             } else {
                                                                                 // 微信返回数据格式不对，无法解析
                                                                                 error = [NSError errorWithDomain:CYShareErrorDomain
                                                                                                             code:CYShareErrorCodeCommon
                                                                                                         userInfo:@{ @"msg": NSLocalizedString(@"微信返回数据格式错误", nil) }];
                                                                             }
                                                                         } else {
                                                                             // 网络请求错误
                                                                             error = [NSError errorWithDomain:CYShareErrorDomain
                                                                                                         code:CYShareErrorCodeCommon
                                                                                                     userInfo:@{ @"msg": NSLocalizedString(@"网络错误", nil) }];
                                                                         }

                                                                         if (callback) {
                                                                             callback(userInfo, nil);
                                                                         }
                                                                     });
                                                                 }];
    [task resume];
}

@end

#endif
