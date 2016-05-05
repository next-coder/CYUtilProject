//
//  CYChatUser.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 2/29/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYChatBaseModel.h"

@interface CYChatUser : CYChatBaseModel

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *headImageUrl;
@property (nonatomic, strong) NSString *nickname;

@end
