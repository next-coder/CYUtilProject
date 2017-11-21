//
//  CYShare+Login.h
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYShare.h"

#if CY_WECHAT_ENABLED
#import "CYWechat+Login.h"
#endif

#if CY_QQ_ENABLED
#import "CYQQ+Login.h"
#endif

#if CY_SINA_WEIBO_ENABLED
#import "CYSinaWeibo+Login.h"
#endif

#if CY_FACEBOOK_ENABLED
#import "CYFacebook+Login.h"
#endif

@interface CYShare (Login)

#if CY_WECHAT_ENABLED

+ (BOOL)loginByWechat:(NSArray<NSString *>*)permissions callback:(CYLoginCallback)callback;
+ (BOOL)loginByWechat:(NSArray<NSString *> *)permissions fromViewController:(UIViewController *)viewController callback:(CYLoginCallback)callback;

#endif


@end
