//
//  CYPersistenceCache.h
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/30/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CYPersistenceCachePolicy) {

    // every other 30 days clear
    // all the file that more than 30 days which unread will be deleted
    CYPersistenceCachePolicyDefault,
//    CYPersistenceCachePolicyRemoveRestart,
//    CYPersistenceCachePolicyRemoveAfterDays,
//    CYPersistenceCachePolicyNoneRemove
};

@interface CYPersistenceCache : NSCache

@property (nonatomic, strong, readonly) NSString *cacheNamespace;
@property (nonatomic, assign, readonly) CYPersistenceCachePolicy cachePolicy;

- (instancetype)initWithNamespace:(NSString *)ns;
- (instancetype)initWithNamespace:(NSString *)ns cachePolicy:(CYPersistenceCachePolicy)cachePolicy;

- (void)setImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk;
- (UIImage *)imageForKey:(NSString *)key;

#pragma mark - default cache
+ (instancetype)defaultCache;

@end
