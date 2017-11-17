//
//  CYLoginInfo.h
//  CYUtilProject
//
//  Created by xn011644 on 16/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYLoginInfo: NSObject

// 登录凭证，由于后续接口调用获取用户各项信息等
@property (nonatomic, copy) NSString *accessToken;

// accessToken过期时间
@property (nonatomic, copy) NSDate *expirationDate;

// 第三方平台返回的用户唯一标识
@property (nonatomic, copy) NSString *userId;

// 由于accessToken有一定的有效期，如果accessToken过期，可使用refreshToken来获取新的accessToken
@property (nonatomic, copy) NSString *refreshToken;

@end
