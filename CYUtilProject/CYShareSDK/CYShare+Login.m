//
//  CYShare+Login.m
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYShare+Login.h"

@implementation CYShare (Login)

#if CY_WECHAT_ENABLED

+ (BOOL)loginByWechat:(NSArray<NSString *>*)permissions callback:(CYLoginCallback)callback {
    return [[CYWechat sharedInstance] loginWithPermissions:permissions callback:callback];
}

+ (BOOL)loginByWechat:(NSArray<NSString *> *)permissions fromViewController:(UIViewController *)viewController callback:(CYLoginCallback)callback {
    return [[CYWechat sharedInstance] loginWithPermissions:permissions fromViewController:viewController callback:callback];
}

#endif

@end
