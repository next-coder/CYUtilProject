//
//  CYShareBaseUtil.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/22/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CYThirdPartyLoginCallback)(NSInteger code, NSString *msg, NSDictionary *resultDic);
typedef void (^CYShareCallback)(NSInteger code, NSString *msg);

@interface CYShareBaseUtil : NSObject

@property (nonatomic, strong, readonly) NSString *appId;
@property (nonatomic, strong, readonly) NSString *appKey;

#pragma mark - app info
// 注册appid和appKey
+ (void)registerWithAppId:(NSString *)appId
                   appKey:(NSString *)appKey;

// 获取注册后的appId和appKey
+ (NSString *)appId;
+ (NSString *)appKey;

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
