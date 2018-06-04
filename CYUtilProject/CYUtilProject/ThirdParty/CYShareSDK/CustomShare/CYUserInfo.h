//
//  CYUserInfo.h
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYUserInfo : NSObject

// 普通用户的标识，对当前开发者帐号唯一
@property (nonatomic, copy) NSString *userId;
// 普通用户昵称
@property (nonatomic, copy) NSString *nickname;
// 用户头像，用户没有头像时该项为空
@property (nonatomic, copy) NSString *headImgUrl;

// 普通用户性别，0未知，1为男性，2为女性
@property (nonatomic, assign) NSInteger gender;

@end
