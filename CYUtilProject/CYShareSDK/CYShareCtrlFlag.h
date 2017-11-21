//
//  CYShareCtrlFlag.h
//  CYUtilProject
//
//  Created by xn011644 on 17/10/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#ifndef CYShareCtrlFlag_h
#define CYShareCtrlFlag_h


// 微信总开关，如果不需要微信，则将此置为0，并且也无需集成微信SDK
// 注意：如果此值为0，则与微信相关的所有功能均不可用，包括分享、登陆和支付
#define CY_WECHAT_ENABLED 1
// 微信登陆开关，如果不需要微信登陆功能，则将此值置为0
// 注意：如果CY_WECHAT_ENABLED=0，则此值被忽略
#define CY_WECHAT_LOGIN_ENABLED 1
// 微信支付开关，如果不需要微信支付功能，则将此值置为0
// 注意：如果CY_WECHAT_ENABLED=0，则此值被忽略
#define CY_WECHAT_PAY_ENABLED 1

// qq总开关，如果不需要，则将此置为0，并且也无需集成QQ SDK
// 注意：如果此值为0，则与qq相关的所有功能均不可用，包括分享、登陆
#define CY_QQ_ENABLED 1
// qq登陆开关，如果不需要qq登陆功能，则将此值置为0
// 注意：如果CY_QQ_ENABLED=0，则此值被忽略
#define CY_QQ_LOGIN_ENABLED 1

// 微博总开关，如果不需要，则将此置为0，并且也无需集成微博SDK
// 注意：如果此值为0，则与微博相关的所有功能均不可用，包括分享、登陆
#define CY_SINA_WEIBO_ENABLED 1
// 微博登陆开关，如果不需要微博登陆功能，则将此值置为0
// 注意：如果CY_SINA_WEIBO_ENABLED=0，则此值被忽略
#define CY_SINA_WEIBO_LOGIN_ENABLED 1

// 是否需要Apple官方提供的分享(UIActivityViewController)
#define CY_SHARE_APPLE_ACTIVITY_ENABLED 1

// 是否需要信息分享(短信，imessage)，如果不需要，则将此置为0，
#define CY_SHARE_SMS_ENABLED 1

// facebook总开关，如果不需要，则将此置为0，并且也无需集成Facebook SDK
// 注意：如果此值为0，则与facebook相关的所有功能均不可用，包括分享、登陆
#define CY_FACEBOOK_ENABLED 1
// facebook登陆开关，如果不需要facebook登陆功能，则将此值置为0
// 注意：如果CY_FACEBOOK_ENABLED=0，则此值被忽略
#define CY_FACEBOOK_LOGIN_ENABLED 1



#endif /* CYShareCtrlFlag_h */
