//
//  CYQQ+Login.h
//  CYUtilProject
//
//  Created by xn011644 on 17/11/2017.
//  Copyright © 2017 Charry. All rights reserved.
//

#import "CYQQ.h"

#if CY_QQ_ENABLED && CY_QQ_LOGIN_ENABLED

#import "CYBaseShare+Login.h"

@class TencentOAuth;


/**
 *  增加QQ登录详细信息，开发者可以从此类别中的属性，获取更多qq登录信息
 */
@interface CYLoginInfo (QQ)

// qq登录详细信息，具体请参见TencentOAuth.h
@property (nonatomic, strong) TencentOAuth *qqOAuth;

@end



/**
 *  增加qq用户详细信息元数据，由qq直接返回，未经过解析的数据
 */
@interface CYUserInfo (QQ)

/*
 qq用户信息接口返回的元数据，包含以下字段

 ret    返回码
 msg    如果ret<0，会有相应的错误信息提示，返回数据全部用UTF-8编码。
 nickname    用户在QQ空间的昵称。
 figureurl    大小为30×30像素的QQ空间头像URL。
 figureurl_1    大小为50×50像素的QQ空间头像URL。
 figureurl_2    大小为100×100像素的QQ空间头像URL。
 figureurl_qq_1    大小为40×40像素的QQ头像URL。
 figureurl_qq_2    大小为100×100像素的QQ头像URL。需要注意，不是所有的用户都拥有QQ的100x100的头像，但40x40像素则是一定会有。
 gender    性别。 如果获取不到则默认返回"男"
 is_yellow_vip    标识用户是否为黄钻用户（0：不是；1：是）。
 vip    标识用户是否为黄钻用户（0：不是；1：是）
 yellow_vip_level    黄钻等级
 level    黄钻等级
 is_yellow_year_vip    标识是否为年费黄钻用户（0：不是； 1：是）

 */
@property (nonatomic, strong) NSDictionary *qqUserInfo;

@end

@interface CYQQ (Login)

- (BOOL)getUserInfoWithCallback:(CYGetUserInfoCallback)callback;

@end

#endif
