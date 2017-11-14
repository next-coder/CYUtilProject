//
//  XNWechatUtil.h
//  MoneyJar2
//
//  Created by XNKJ on 6/4/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYShareCtrlFlag.h"

#if CY_SHARE_WECHAT_ENABLED

#import <UIKit/UIKit.h>
#import "CYBaseShare.h"

@class CYShareModel;
@class CYWechatAccessToken;
@class CYWechatUserInfo;
@class CYWechatPayInfo;

typedef NS_ENUM(int, CYWechatScene) {

    CYWechatSceneSession = 0, // 聊天界面
    CYWechatSceneTimeline = 1, // 朋友圈
    CYWechatSceneFavorite = 2, // 收藏
};

typedef NS_ENUM(NSInteger, CYWechatErrorCode) {
    CYWechatErrorCodeSuccess           = 0,    /**< 成功    */
    CYWechatErrorCodeCommon     = -1,   /**< 普通错误类型    */
    CYWechatErrorCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    CYWechatErrorCodeSentFail   = -3,   /**< 发送失败    */
    CYWechatErrorCodeAuthDeny   = -4,   /**< 授权失败    */
    CYWechatErrorCodeUnsupport  = -5,   /**< 微信不支持    */
};

#pragma mark - share
// 此类采用单例模式，请直接使用sharedInstance，不要创建新实例
@interface CYWechat : CYBaseShare <UIActionSheetDelegate>

extern NSString *const CYWechatSceneKey;
/**
 *
 * 如果使用此方法分享，model的userInfo属性可以包含key 为CYWechatSceneKey，值为CYWechatScene中的一个，
 * 用于标识分享的目标，如果未包含，则调用share:presentActionSheetFrom:callback:进行分享
 *
 */
- (void)share:(CYShareModel *)model callback:(CYShareCallback)callback;

/**
 *
 * 使用此方法分享，让用户选择分享到朋友圈或者微信好友
 *
 */
- (void)share:(CYShareModel *)model
presentActionSheetFrom:(UIViewController *)viewController
     callback:(CYShareCallback)callback;

/**
 * 分享到微信朋友圈
 *
 * @param model  待分享的内容
 * @param callback 分享完成后回调
 *
 */
- (void)shareToTimeline:(CYShareModel *)model
               callback:(CYShareCallback)callback;

/**
 * 分享给微信好友
 *
 * @param model  待分享的内容
 * @param callback 分享完成后回调
 *
 */
- (void)shareToSession:(CYShareModel *)model
              callback:(CYShareCallback)callback;

/**
 * 分享到微信，指定微信的scene
 *
 */
- (void)share:(CYShareModel *)model
           to:(CYWechatScene)scene
     callback:(CYShareCallback)callback;

#pragma mark - handle open url
/**
 * 需要在AppDelegate的- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 方法中调用此方法，来处理结果
 */
- (BOOL)handleOpenURL:(NSURL *)URL;

#pragma mark - static single
+ (instancetype)sharedInstance;

@end

#pragma mark - wechat login
// 微信登陆回调
typedef void (^CYWechatLoginCallback)(NSInteger errorCode,
                                      NSString *msg,
                                      NSString *wechatCode);
// 微信获取access token 回调
typedef void (^CYWechatAccessTokenCallback)(NSInteger errorCode,
                                            NSString *msg,
                                            CYWechatAccessToken *wechatToken);
// 微信获取用户信息回调
typedef void (^CYWechatUserInfoCallback)(NSInteger errorCode,
                                         NSString *msg,
                                         CYWechatUserInfo *wechatToken);

@interface CYWechat (Login)

// 最新获取的微信accessToken缓存，
// 在第一次调用获取accessToken或者刷新accessToken之前为空
// 如果调用获取accessToken或者刷新accessToken成功获取到新的accessToken，则此属性值为最近一次调用成功的缓存
@property (nonatomic, strong, readonly) CYWechatAccessToken *accessToken;
// 最新获取的微信userInfo缓存
// 在第一次调用获取userInfo之前为空
// 如果调用获取userInfo成功获取到新的userInfo，则此属性值为最近一次调用成功的缓存
@property (nonatomic, strong, readonly) CYWechatUserInfo *userInfo;

/**
 *  微信登陆
 *
 *  @param from     没有安装微信时，用于web登陆present
 *  @param callback 登陆回调
 */
- (void)loginFrom:(UIViewController *)from
         callback:(CYWechatLoginCallback)callback;

/**
 *  微信获取access token
 *
 *  @param code     微信登陆后返回的code
 *  @param callback 获取access token 完成后回调
 */
- (void)getAccessTokenWithCode:(NSString *)code
                      callback:(CYWechatAccessTokenCallback)callback;

/**
 *  微信刷新access token
 *
 *  @param refreshToken 获取AccessToken接口返回的refreshToken
 *  @param callback 获取access token 完成后回调
 */
- (void)refreshAccessTokenWithRefreshToken:(NSString *)refreshToken
                                  callback:(CYWechatAccessTokenCallback)callback;

/**
 *  获取微信用户信息
 *
 *  @param accessToken 获取AccessToken接口返回的accessToken
 *  @param openid 获取AccessToken接口返回的openid
 *  @param callback 获取access token 完成后回调
 */
- (void)getUserInfoWithAccessToken:(NSString *)accessToken
                            openid:(NSString *)openid
                          callback:(CYWechatUserInfoCallback)callback;

@end

#pragma mark - wechat access token data
/**
 *  微信获取和刷新access token的返回数据
 */
@interface CYWechatAccessToken : NSObject

// 接口调用凭证
@property (nonatomic, copy) NSString *accessToken;
// access_token接口调用凭证超时时间，单位（秒）
@property (nonatomic, assign) NSTimeInterval expiresIn;
// 用户刷新access_token
@property (nonatomic, copy) NSString *refreshToken;
// 授权用户唯一标识
@property (nonatomic, copy) NSString *openid;
// 用户授权的作用域，使用逗号（,）分隔
@property (nonatomic, copy) NSString *scope;
// 当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
@property (nonatomic, copy) NSString *unionid;

// 获取accesstoken接口，微信返回的原始数据
@property (nonatomic, strong) NSData *originData;

@end

#pragma mark - wechat user info
/**
 *  微信用户信息
 */
@interface CYWechatUserInfo: NSObject

// 普通用户的标识，对当前开发者帐号唯一
@property (nonatomic, copy) NSString *openid;
// 普通用户昵称
@property (nonatomic, copy) NSString *nickname;
// 普通用户个人资料填写的省份
@property (nonatomic, copy) NSString *province;
// 普通用户个人资料填写的城市
@property (nonatomic, copy) NSString *city;
// 国家，如中国为CN
@property (nonatomic, copy) NSString *country;
// 用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空
@property (nonatomic, copy) NSString *headimgurl;
// 用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。
@property (nonatomic, copy) NSString *unionid;

// 用户特权信息，json数组，如微信沃卡用户为（chinaunicom）
@property (nonatomic, strong) NSArray *privilege;

// 普通用户性别，1为男性，2为女性
@property (nonatomic, assign) NSInteger sex;

@end

#pragma mark - pay
typedef void (^CYWechatPayCallback)(NSInteger errorCode, NSString *msg, NSString *returnKey);

@interface CYWechat (Pay)

/**
 *  调起微信支付
 *
 *  在调用此方法之前，开发者必须自行调用微信支付的统一下单接口获取相关支付信息
 *  具体请参考微信支付官方文档：https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1
 *
 */
- (void)payWithInfo:(CYWechatPayInfo *)payInfo
           callback:(CYWechatPayCallback)callback;

/**
 *  调起微信支付
 *
 *  通过一个字典完成微信支付，字典中必须包含以下信息
 *  partnerId   商家向财付通申请的商家id
 *  prepayId    预支付订单
 *  package     商家根据财付通文档填写的数据和签名
 *  nonceStr    随机串，防重发
 *  sign        商家根据微信开放平台文档对数据做的签名
 *  timeStamp   时间戳，防重发
 *
 */
- (void)payWithInfoDictionary:(NSDictionary *)payInfoDic
                     callback:(CYWechatPayCallback)callback;

//- (void)payWithInfoJSON:(NSData *)jsonData
//               callback:(CYWechatPayCallback)callback;

@end

@interface CYWechatPayInfo: NSObject

// 商家向财付通申请的商家id
@property (nonatomic, copy) NSString *partnerId;
// 预支付订单
@property (nonatomic, copy) NSString *prepayId;
// 商家根据财付通文档填写的数据和签名
@property (nonatomic, copy) NSString *package;
// 随机串，防重发
@property (nonatomic, copy) NSString *nonceStr;
// 商家根据微信开放平台文档对数据做的签名
@property (nonatomic, copy) NSString *sign;

// 时间戳，防重发
@property (nonatomic, assign) UInt32 timeStamp;

/**
 *  以字典形式初始化
 *  字典中的key必须与属性名一一对应
 *
 */
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

#endif

