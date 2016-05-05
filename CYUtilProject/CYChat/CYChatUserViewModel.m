//
//  CYChatUserViewModel.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYChatUserViewModel.h"

@implementation CYChatUserViewModel

- (instancetype)initWithUser:(CYChatUser *)user {
    
    if (self = [super init]) {
        
        _user = user;
    }
    return self;
}

#pragma mark - getter
- (NSString *)userId {
    
    return _user.userId;
}

- (NSString *)headImageUrl {
    
    return _user.headImageUrl;
}

- (NSString *)nickname {
    
    return _user.nickname;
}

@end
