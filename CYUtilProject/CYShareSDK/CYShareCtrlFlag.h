//
//  CYShareCtrlFlag.h
//  CYUtilProject
//
//  Created by xn011644 on 17/10/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#ifndef CYShareCtrlFlag_h
#define CYShareCtrlFlag_h


// 是否需要微信分享，如果不需要，则将此置为0，并且也无需集成微信SDK
#define CY_SHARE_WECHAT_ENABLED 1
// 是否需要qq分享，如果不需要，则将此置为0，并且也无需集成QQ SDK
#define CY_SHARE_QQ_ENABLED 1
// 是否需要微博分享，如果不需要，则将此置为0，并且也无需集成微博SDK
#define CY_SHARE_SINA_WEIBO_ENABLED 1
// 是否需要Apple官方提供的分享(UIActivityViewController)，默认关闭，如果需要打开，则将此置为1
#define CY_SHARE_APPLE_ACTIVITY_ENABLED 1
// 是否需要信息分享(短信，imessage)，如果不需要，则将此置为0，
#define CY_SHARE_SMS_ENABLED 1


#endif /* CYShareCtrlFlag_h */
