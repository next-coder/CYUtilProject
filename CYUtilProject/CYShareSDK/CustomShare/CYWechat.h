//
//  XNWechatUtil.h
//  MoneyJar2
//
//  Created by XNKJ on 6/4/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "CYShareCtrlFlag.h"

#if CY_WECHAT_ENABLED

#import <UIKit/UIKit.h>
#import "CYBaseShare.h"

#import "WXApi.h"

@class CYShareModel;
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
@interface CYWechat : CYBaseShare <UIActionSheetDelegate, WXApiDelegate>

extern NSString *const CYWechatSceneKey;
/**
 *
 * 如果使用此方法分享，model的userInfo属性可以包含key 为CYWechatSceneKey，值为CYWechatScene中的一个，
 * 用于标识分享的目标，如果未包含，则调用share:fromViewController:callback:进行分享
 *
 */
- (void)share:(CYShareModel *)model callback:(CYShareCallback)callback;

/**
 *
 * 使用此方法分享，让用户选择分享到朋友圈或者微信好友
 *
 */
- (void)share:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback;

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

#pragma mark - static single
+ (instancetype)sharedInstance;

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

