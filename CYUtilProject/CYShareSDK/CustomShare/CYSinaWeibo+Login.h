//
//  CYSinaWeibo+Login.h
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYSinaWeibo.h"

#if CY_SINA_WEIBO_ENABLED && CY_SINA_WEIBO_LOGIN_ENABLED

#import "CYBaseShare+Login.h"

@class WBAuthorizeResponse;
/**
 *  增加新浪微博登录后详细信息
 */
@interface CYLoginInfo (SinaWeibo)

// 微博登录后详细信息，具体请参考WeiboSDK.h
@property (nonatomic, strong) WBAuthorizeResponse *sinaWeiboAuthorizeResponse;

@end


@class WeiboUser;
/**
 *  增加新浪微博返回的用户详细信息
 */
@interface CYUserInfo (SinaWeibo)

// 新浪微博接口返回的详细信息，具体请参考http://open.weibo.com/wiki/2/users/show
@property (nonatomic, strong) WeiboUser *sinaWeiboUserInfo;

@end

@interface CYSinaWeibo (Login)

@end

#endif
