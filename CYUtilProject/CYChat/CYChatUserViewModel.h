//
//  CYChatUserViewModel.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatUser.h"

@interface CYChatUserViewModel : NSObject

- (instancetype)initWithUser:(CYChatUser *)user;

@property (nonatomic, strong, readonly) CYChatUser *user;

@property (nonatomic, strong, readonly) NSString *userId;

@property (nonatomic, strong, readonly) NSString *headImageUrl;
@property (nonatomic, strong, readonly) NSString *nickname;

@end
