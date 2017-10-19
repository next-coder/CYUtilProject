//
//  CYSMS.h
//  CYUtilProject
//
//  Created by xn011644 on 18/10/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYShareCtrlFlag.h"

#if CY_SHARE_SMS_ENABLED

#import "CYBaseShare.h"

@class UIViewController;

@interface CYSMS : CYBaseShare

extern NSString *const CYSMSToUsersKey;

/**
 发送信息分享，使用此方法时，可以在model.userInfo中包含Key为CYSMSToUsersKey的值，用于发送对象的手机号列表
 CYSMSToUsersKey对应的值的类型可以是字符串或者字符串数组
 */
- (void)share:(CYShareModel *)model
     callback:(CYShareCallback)callback;

- (void)share:(CYShareModel *)model
           to:(NSString *)mobile
  presentFrom:(UIViewController *)viewController
     callback:(CYShareCallback)callback;

- (void)share:(CYShareModel *)model
      toUsers:(NSArray *)mobiles
  presentFrom:(UIViewController *)viewController
     callback:(CYShareCallback)callback;

#pragma mark - sharedInstance
+ (instancetype)sharedInstance;

@end

#endif
