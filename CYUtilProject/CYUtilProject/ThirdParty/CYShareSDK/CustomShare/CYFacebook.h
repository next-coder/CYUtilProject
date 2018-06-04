//
//  CYFacebook.h
//  CYUtilProject
//
//  Created by xn011644 on 16/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYShareCtrlFlag.h"

#if CY_FACEBOOK_ENABLED

#import "CYBaseShare.h"
#import "CYBaseShare+Login.h"

@class UIViewController;
@class UIApplication;

@interface CYFacebook : CYBaseShare

/**
 * 分享到Facebook
 * 弹出Facebook dialog进行分享，仅支持链接和图片分享
 * 链接分享时，model中的content和url有效
 * 图片分享时，model中的url和data有效
 *
 */
- (void)share:(CYShareModel *)model fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback;

/**
 * 分享多张图片到Facebook
 * 弹出Facebook dialog进行分享
 * models中类型为CYShareContentImage的model有效，其他忽略
 * model中的url和data有效，其他字段均忽略
 *
 */
- (void)shareImages:(NSArray *)models fromViewController:(UIViewController *)viewController callback:(CYShareCallback)callback;

#pragma mark - static
+ (instancetype)sharedInstance;

@end

#endif
