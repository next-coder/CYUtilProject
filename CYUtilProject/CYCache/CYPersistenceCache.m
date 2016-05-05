//
//  CYPersistenceCache.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/30/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

#import "CYPersistenceCache.h"

@interface CYPersistenceCache ()

@property (nonatomic, strong) NSString *diskCachePath;

@end

@implementation CYPersistenceCache

- (instancetype)init {
    
    return [self initWithNamespace:nil];
}

- (id)initWithNamespace:(NSString *)ns {
    
    if (self = [super init]) {
        
        _cacheNamespace = ns;
        
        if (!_cacheNamespace) {
            
            _cacheNamespace = @"default";
        }
        
        NSString *fullNamespace = [NSString stringWithFormat:@"com.xiaoniuapp.cache.%@", _cacheNamespace];
        _diskCachePath = [self makeDiskCachePath:fullNamespace];
        self.totalCostLimit = 100 * 1024 * 1024;
    }
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk {
    [self setObject:image forKey:key cost:(image.size.width * image.size.height * 8)];
    
    if (toDisk) {
        
        [self saveImageToDisk:image forKey:key];
    }
}

- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk {
    [self removeObjectForKey:key];
    
    if (fromDisk) {
        
        [self removeImageFromDiskForKey:key];
    }
}

- (UIImage *)imageForKey:(NSString *)key {
    
    UIImage *image = [self objectForKey:key];
    if (!image) {
        
        image = [self imageForKeyFromDisk:key];
        if (image) {
            
            [self setObject:image forKey:key cost:(image.size.width * image.size.height * 8)];
        }
    }
    return image;
}

#pragma mark - private disk save
- (void)saveImageToDisk:(UIImage *)image forKey:(NSString *)key {
    
    if (!image
        || !key) {
        return;
    }
    
    NSString *savePath = [self defaultCachePathForKey:key];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:_diskCachePath]) {
        
        [manager createDirectoryAtPath:_diskCachePath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return;
    }
    
    [manager createFileAtPath:savePath contents:imageData attributes:nil];
    
    // 不备份
    [[NSURL fileURLWithPath:savePath] setResourceValue:[NSNumber numberWithBool:YES]
                                                forKey:NSURLIsExcludedFromBackupKey
                                                 error:NULL];
}

- (void)removeImageFromDiskForKey:(NSString *)key {
    
    if (!key) {
        return;
    }
    NSString *savePath = [self defaultCachePathForKey:key];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:savePath error:NULL];
}

- (UIImage *)imageForKeyFromDisk:(NSString *)key {
    
    if (!key) {
        return nil;
    }
    
    NSString *savePath = [self defaultCachePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:savePath];
    if (data) {
        
        return [UIImage imageWithData:data];
    }
    return nil;
}

#pragma mark - private save path
- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path {
    NSString *filename = [self cachedFileNameForKey:key];
    return [path stringByAppendingPathComponent:filename];
}

- (NSString *)defaultCachePathForKey:(NSString *)key {
    return [self cachePathForKey:key inPath:self.diskCachePath];
}

- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (NSString *)makeDiskCachePath:(NSString*)fullNamespace{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

#pragma mark - default cache
+ (instancetype)defaultCache {
    
    static CYPersistenceCache *defaultCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        defaultCache = [[CYPersistenceCache alloc] initWithNamespace:nil];
    });
    return defaultCache;
}

@end
