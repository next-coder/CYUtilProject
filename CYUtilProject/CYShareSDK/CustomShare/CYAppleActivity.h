//
//  CYAppleSocial.h
//  CYUtilProject
//
//  Created by xn011644 on 18/10/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYShareCtrlFlag.h"

#if CY_SHARE_APPLE_ACTIVITY_ENABLED

#import "CYBaseShare.h"

@class UIViewController;

/**
 *  通过iOS系统提供的UIActivityViewController来分享
 *
 */
@interface CYAppleActivity : CYBaseShare

/**
 *  通过iOS系统提供的UIActivityViewController来分享
 *
 *  通过调用- (void)share:presentFrom:callback:来实现
 *  其中presentFrom使用[[[UIApplication sharedApplication] keyWindow] rootViewController]
 *
 */
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback;

/**
 *  通过iOS系统提供的UIActivityViewController来分享
 *
 *  弹出ActionSheet选择分享到哪个网站
 *
 */
- (void)share:(CYShareModel *)model
  presentFrom:(UIViewController *)viewController
     callback:(CYShareCallback)callback;

#pragma mark - sharedInstance
+ (instancetype)sharedInstance;

@end

#endif
