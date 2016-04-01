//
//  CYShareBaseUtil.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 3/22/16.
//  Copyright © 2016 Charry. All rights reserved.
//

#import "CYShareBaseUtil.h"

@interface CYShareAppInfo : NSObject

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *appKey;

@end

@implementation CYShareAppInfo

- (instancetype)initWithAppId:(NSString *)appId appKey:(NSString *)appKey {
    
    if (self = [super init]) {
        
        _appId = appId;
        _appKey = appKey;
    }
    return self;
}

@end

@implementation CYShareBaseUtil

- (NSString *)appId {
    
    return [[self class] appId];
}

- (NSString *)appKey {
    
    return [[self class] appKey];
}

#pragma mark - property
static NSMutableDictionary *shareAppInfos;

+ (void)registerWithAppId:(NSString *)appId
                   appKey:(NSString *)appKey {
    
    if (!appId
        && !appKey) {
        
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareAppInfos = [NSMutableDictionary dictionary];
    });
    
    CYShareAppInfo *info = [[CYShareAppInfo alloc] initWithAppId:appId appKey:appKey];
    [shareAppInfos setObject:info
                      forKey:NSStringFromClass(self)];
}

+ (NSString *)appId {
    
    CYShareAppInfo *info = [shareAppInfos objectForKey:NSStringFromClass(self)];
    return info.appId;
}

+ (NSString *)appKey {
    
    CYShareAppInfo *info = [shareAppInfos objectForKey:NSStringFromClass(self)];
    return info.appKey;
}

#pragma mark - api
+ (BOOL)openApp {
    
    return NO;
}

+ (BOOL)appInstalled {
    
    return NO;
}

#pragma mark - shared instance
+ (instancetype)sharedInstance {
    
    return nil;
}

@end
