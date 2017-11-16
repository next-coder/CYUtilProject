//
//  CYQQUtils.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/10/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYShareCtrlFlag.h"

#if CY_SHARE_QQ_ENABLED
#import "CYBaseShare.h"

@class CYShareModel;
//@class CYQQLoginInfo;
@class CYQQUserInfo;
@class UIViewController;

typedef NS_ENUM(uint64_t, CYQQAPICtrlFlag) {
    CYQQAPICtrlFlagQZoneShareOnStart = 0x01, // QZone
    CYQQAPICtrlFlagQZoneShareForbid = 0x02,
    CYQQAPICtrlFlagQQShare = 0x04,  // qq好友
    CYQQAPICtrlFlagQQShareFavorites = 0x08, //收藏
    CYQQAPICtrlFlagQQShareDataline = 0x10 //数据线
};

// 此类采用单例模式，请直接使用sharedInstance，不要创建新实例
@interface CYQQ : CYBaseShare

extern NSString *const CYQQAPICtrlFlagKey;

#pragma mark - share url
/**
 * 如果使用此方法分享，model的userInfo属性可以包含key 为CYQQAPICtrlFlagKey，值为CYQQAPICtrlFlag中的一个，
 * 用于标识分享的目标，如果未包含，则调用share:presentActionSheetFrom:callback:进行分享
 */
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback;

/**
 * 分享到QQ
 * 弹出ActionSheet，让用户选择分享到QQ好友或者QQ空间
 *
 */
- (void)share:(CYShareModel *)model
presentActionSheetFrom:(UIViewController *)viewController
     callback:(CYShareCallback)callback;

/**
 * 分享给QQ好友
 *
 */
- (void)shareToQQ:(CYShareModel *)model
         callback:(CYShareCallback)callback;

/**
 * 分享到QQ空间
 *
 */
- (void)shareToQZone:(CYShareModel *)model
            callback:(CYShareCallback)callback;


/**
 * 分享到制定的QQ目标
 *
 */
- (void)share:(CYShareModel *)model
           to:(CYQQAPICtrlFlag)flag
     callback:(CYShareCallback)callback;


#pragma mark - handle open
/**
 * 需要在AppDelegate的- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 方法中调用此方法，来处理结果
 */
- (BOOL)handleOpenURL:(NSURL *)url;

#pragma mark - sharedInstance
+ (instancetype)sharedInstance;

@end

#pragma mark - qq login

//typedef void (^CYQQLoginCallback)(NSInteger errorCode, NSString *msg, CYQQLoginInfo *loginInfo);
typedef void (^CYQQUserInfoCallback)(NSInteger errorCode, NSString *msg, CYQQUserInfo *userInfo);

@interface CYQQ (Login)

//// 缓存登录信息，未登录情况下为空
//@property (nonatomic, strong, readonly) CYQQLoginInfo *loginInfo;
// 缓存用户信息，第一次成功获取到用户信息之前为空，之后则为最新一次获取到的用户信息
@property (nonatomic, strong, readonly) CYQQUserInfo *userInfo;

/**
 *  qq登录
 *  @param permissions 需要的权限列表，参考QQ SDK中的sdkdef.h
 *  @param callback 登录完成回调
 */
- (void)loginWithPermissions:(NSArray *)permissions
                    callback:(CYLoginCallback)callback;

/**
 *  qq登录，采用kOPEN_PERMISSION_GET_SIMPLE_USER_INFO权限进行登录
 *  @param callback 登录完成回调
 */
- (void)loginWithCallback:(CYLoginCallback)callback;

@end



//#pragma mark - logininfo model
///**
// *  qq登录信息model
// *
// *  qq登录成功之后，回调中包含此model，用来标识用户登录相关信息
// *
// */
//@interface CYQQLoginInfo: NSObject
//
///** Access Token凭证，用于后续访问各开放接口 */
//@property(nonatomic, copy) NSString* accessToken;
//
///** Access Token的失效期 */
//@property(nonatomic, copy) NSDate* expirationDate;
//
///** 用户授权登录后对该用户的唯一标识 */
//@property(nonatomic, copy) NSString* openId;
//
//+ (instancetype)instanceFromCurrentQQOAuth;
//
//@end

@class TencentOAuth;
@interface CYLoginInfo (QQ)

@property (nonatomic, strong) TencentOAuth *qqOAuth;

@end



#pragma mark - userinfo model
/**
 *  qq用户信息model
 *
 *  调用获取用户信息接口时，如果调用成功，则回调block中的参数包含此对象
 *
 */
@interface CYQQUserInfo: NSObject

// 用户在QQ空间的昵称。
@property (nonatomic, copy) NSString *nickname;
// 大小为30×30像素的QQ空间头像URL。
@property (nonatomic, copy) NSString *figureurl;
// 大小为50×50像素的QQ空间头像URL。
@property (nonatomic, copy) NSString *figureurl_1;
// 大小为100×100像素的QQ空间头像URL。
@property (nonatomic, copy) NSString *figureurl_2;
// 大小为40×40像素的QQ头像URL。
@property (nonatomic, copy) NSString *figureurl_qq_1;
// 大小为100×100像素的QQ头像URL。需要注意，不是所有的用户都拥有QQ的100x100的头像，但40x40像素则是一定会有。
@property (nonatomic, copy) NSString *figureurl_qq_2;
// 性别。 如果获取不到则默认返回"男"
@property (nonatomic, copy) NSString *gender;
// 标识用户是否为黄钻用户（0：不是；1：是）。
@property (nonatomic, copy) NSString *isYellowVip;
// 标识用户是否为黄钻用户（0：不是；1：是）
@property (nonatomic, copy) NSString *vip;
// 黄钻等级
@property (nonatomic, copy) NSString *yellowVipLevel;
// 黄钻等级
@property (nonatomic, copy) NSString *level;
// 标识是否为年费黄钻用户（0：不是； 1：是）
@property (nonatomic, copy) NSString *isYellowYearVip;


@end

#endif
