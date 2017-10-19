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

@interface CYAppleActivity : CYBaseShare

- (void)share:(CYShareModel *)model
  presentFrom:(UIViewController *)viewController
     callback:(CYShareCallback)callback;

#pragma mark - sharedInstance
+ (instancetype)sharedInstance;

@end

#endif
