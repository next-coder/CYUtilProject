//
//  CYShareBaseUtil.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/22/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYShareModel;

typedef void (^CYLoginCallback)(NSInteger code, NSString *msg, NSDictionary *resultDic);
typedef void (^CYShareCallback)(NSInteger code, NSString *msg);

@interface CYBaseShare : NSObject

@property (nonatomic, strong, readonly) NSString *appId;
@property (nonatomic, strong, readonly) NSString *appKey;

@property (nonatomic, copy) CYShareCallback shareCallback;

#pragma mark - share
// Subclass should implements this method to implement the share action
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback;

#pragma mark - app info
// 注册appid和appKey
// 微信和QQ必须注册Appid，微博必须注册AppKey
- (void)registerAppId:(NSString *)appId;
- (void)registerAppKey:(NSString *)appKey;

#pragma mark - api
/**
 *  打开App
 *
 *  @return YES打开成功，NO打开失败
 */
+ (BOOL)openApp;

/*! @brief 检查App是否已被用户安装
 *
 * @return 已安装返回YES，未安装返回NO。
 */
+ (BOOL)appInstalled;

@end
