//
//  CYQQUtils.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/10/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYQQUtils.h"

#import "TencentOpenApi/TencentOAuth.h"
#import "TencentOpenApi/TencentApiInterface.h"

@interface CYQQUtils () <TencentSessionDelegate>

@end

@implementation CYQQUtils

- (instancetype)init {
    
    if (self = [super init]) {
        
        TencentOAuth *oauth = [[TencentOAuth alloc] initWithAppId:@"" andDelegate:self];
        NSArray *permissions = @[ kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE ];
        [oauth authorize:permissions inSafari:NO];
    }
    return self;
}

#pragma mark - login
- (void)tencentDidLogin {
    
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
    
}

- (void)tencentDidNotNetWork {
    
    
}

@end
