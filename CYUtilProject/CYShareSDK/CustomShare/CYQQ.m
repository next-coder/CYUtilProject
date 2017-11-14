//
//  CYQQUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/10/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYQQ.h"

#if CY_SHARE_QQ_ENABLED
#import <UIKit/UIKit.h>
#import "CYShareModel.h"

#import "TencentOpenApi/TencentOAuth.h"
#import "TencentOpenApi/QQApiInterface.h"

@interface CYQQ() <TencentSessionDelegate, QQApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth *oauth;
@property (nonatomic, copy) CYQQLoginCallback loginCallback;
@property (nonatomic, copy) CYQQUserInfoCallback userInfoCallback;

@property (nonatomic, strong, readwrite) CYQQLoginInfo *loginInfo;
// 缓存用户信息，第一次成功获取到用户信息之前为空，之后则为最新一次获取到的用户信息
@property (nonatomic, strong, readwrite) CYQQUserInfo *userInfo;

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
    self.loginInfo = [CYQQLoginInfo instanceFromCurrentQQOAuth];
    if (self.loginCallback) {
        self.loginCallback(0,
                           NSLocalizedString(@"success", nil),
                           self.loginInfo);
        self.loginCallback = nil;
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (self.loginCallback) {
        self.loginCallback(-1,
                           NSLocalizedString(@"user cancelled", nil),
                           [CYQQLoginInfo instanceFromCurrentQQOAuth]);
        self.loginCallback = nil;
    }
    self.loginInfo = nil;
}

- (void)tencentDidNotNetWork {
    if (self.loginCallback) {
        self.loginCallback(-2,
                           NSLocalizedString(@"network error", nil),
                           [CYQQLoginInfo instanceFromCurrentQQOAuth]);
        self.loginCallback = nil;
    }
    self.loginInfo = nil;
}

- (void)tencentDidLogout {
    self.loginInfo = nil;
}

#pragma mark - share
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback {

    id flag = [model.userInfo objectForKey:CYQQAPICtrlFlagKey];
    if (flag && [flag isKindOfClass:[NSNumber class]]) {

        [self share:model
                 to:[flag unsignedLongLongValue]
           callback:callback];
    } else {

        [self share:model
presentActionSheetFrom:[[[UIApplication sharedApplication] keyWindow] rootViewController]
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

#pragma mark - handle open
- (BOOL)handleOpenURL:(NSURL *)url {
    
    return [QQApiInterface handleOpenURL:url delegate:self];
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

//+ (void)registerWithAppId:(NSString *)appId appKey:(NSString *)appKey {
//    [super registerWithAppId:appId appKey:appKey];
//
////    QQApiInterface
//}

@end

#pragma mark - qq login
@interface CYQQUserInfo()

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@implementation CYQQ (Login)

- (void)loginWithPermissions:(NSArray *)permissions
                    callback:(CYQQLoginCallback)callback {
    self.loginCallback = callback;
    [self.oauth authorize:permissions];
}

- (void)loginWithCallback:(CYQQLoginCallback)callback {
    [self loginWithPermissions:@[ kOPEN_PERMISSION_GET_SIMPLE_USER_INFO ]
                      callback:callback];
}

- (void)getUserInfoWithCallback:(CYQQUserInfoCallback)callback {
    self.userInfoCallback = callback;
    BOOL result = [self.oauth getUserInfo];
    if (!result) {
        callback(-1, NSLocalizedString(@"Call failed", nil), nil);
        self.userInfoCallback = nil;
    }
}

- (void)getUserInfoResponse:(APIResponse *)response {
    NSInteger code = response.retCode;
    NSString *msg = response.errorMsg;
    CYQQUserInfo *userInfo = nil;
    if (code == URLREQUEST_SUCCEED) {
        userInfo = [[CYQQUserInfo alloc] initWithDictionary:response.jsonResponse];
        self.userInfo = userInfo;
    }
    if (self.userInfoCallback) {
        self.userInfoCallback(code, msg, userInfo);
        self.userInfoCallback = nil;
    }
}

@end

#pragma mark - logininfo model
@implementation CYQQLoginInfo

+ (instancetype)instanceFromCurrentQQOAuth {

    TencentOAuth *oauth = [[CYQQ sharedInstance] oauth];

    CYQQLoginInfo *info = [[CYQQLoginInfo alloc] init];
    info.accessToken = oauth.accessToken;
    info.expirationDate = oauth.expirationDate;
    info.openId = oauth.openId;
    return info;
}

@end

#pragma mark - userinfo model
@implementation CYQQUserInfo

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {

        if (dic
            && [dic isKindOfClass:[NSDictionary class]]
            && dic.count > 0) {

            _nickname = dic[@"nickname"];
            _figureurl = dic[@"figureurl"];
            _figureurl_1 = dic[@"figureurl_1"];
            _figureurl_2 = dic[@"figureurl_2"];
            _figureurl_qq_1 = dic[@"figureurl_qq_1"];
            _figureurl_qq_2 = dic[@"figureurl_qq_2"];
            _gender = dic[@"gender"];
            _isYellowVip = dic[@"is_yellow_vip"];
            _vip = dic[@"vip"];
            _yellowVipLevel = dic[@"yellow_vip_level"];
            _level = dic[@"level"];
            _isYellowYearVip = dic[@"is_yellow_year_vip"];
        }
    }
    return self;
}

@end

#endif
