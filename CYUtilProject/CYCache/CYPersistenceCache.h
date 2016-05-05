//
//  CYPersistenceCache.h
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/30/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYPersistenceCache : NSCache

@property (nonatomic, strong, readonly) NSString *cacheNamespace;

- (id)initWithNamespace:(NSString *)ns;

- (void)setImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk;
- (UIImage *)imageForKey:(NSString *)key;

#pragma mark - default cache
+ (instancetype)defaultCache;

@end
