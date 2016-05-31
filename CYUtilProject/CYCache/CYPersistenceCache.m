//
//  CYPersistenceCache.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/30/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import <sys/xattr.h>

#import "CYPersistenceCache.h"

@interface CYPersistenceCache ()

@property (nonatomic, strong) NSString *diskCachePath;

@end

@implementation CYPersistenceCache

- (instancetype)init {
    
    return [self initWithNamespace:nil];
}

- (instancetype)initWithNamespace:(NSString *)ns {
    
    return [self initWithNamespace:ns cachePolicy:CYPersistenceCachePolicyDefault];
}

- (instancetype)initWithNamespace:(NSString *)ns cachePolicy:(CYPersistenceCachePolicy)cachePolicy {

    if (self = [super init]) {

        _cacheNamespace = ns;
        _cachePolicy = cachePolicy;

        if (!_cacheNamespace) {

            _cacheNamespace = @"default";
        }

        NSString *fullNamespace = [NSString stringWithFormat:@"com.xiaoniuapp.cache.%@", _cacheNamespace];
        _diskCachePath = [self makeDiskCachePath:fullNamespace];
        self.totalCostLimit = 100 * 1024 * 1024;

        [self startClearCacheAsyncIfNeeded];
    }
    return self;
}

#pragma mark - save image
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
    NSFileManager *manager = [CYPersistenceCache persistanceSharedManager];
    
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

    // refresh last read date
    [self refreshFileLastReadDate:savePath];

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
    NSFileManager *manager = [CYPersistenceCache persistanceSharedManager];
    [manager removeItemAtPath:savePath error:NULL];
}

- (UIImage *)imageForKeyFromDisk:(NSString *)key {
    
    if (!key) {
        return nil;
    }

    NSString *savePath = [self defaultCachePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:savePath];
    if (data) {

        // refresh read date
        [self refreshFileLastReadDate:savePath];
        return [UIImage imageWithData:data];
    }
    return nil;
}

static NSString *const fileLastReadDateAttributeKey = @"kCYLastReadDate";
- (void)refreshFileLastReadDate:(NSString *)filePath {

    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    const char *value = [[NSString stringWithFormat:@"%.0f", time] UTF8String];
    setxattr([filePath fileSystemRepresentation],
             [fileLastReadDateAttributeKey UTF8String],
             value,
             strlen(value),
             0,
             0);
}

- (NSDate *)fileLastReadDate:(NSString *)filePath {

    const char *filePathC = [filePath fileSystemRepresentation];
    const char *attrName = [fileLastReadDateAttributeKey UTF8String];

    // get size of needed buffer
    int bufferLength = getxattr(filePathC,
                                attrName,
                                NULL,
                                0,
                                0,
                                0);

    // make a buffer of sufficient length
    char *buffer = malloc(bufferLength);

    // now actually get the attribute string
    getxattr(filePathC, attrName, buffer, 255, 0, 0);

    // convert to NSString
    NSString *retString = [[NSString alloc] initWithBytes:buffer
                                                   length:bufferLength
                                                 encoding:NSUTF8StringEncoding];
    
    // release buffer
    free(buffer);

    if (retString) {

        NSTimeInterval time = (NSTimeInterval)[retString doubleValue];
        if (time > 0) {

            return [NSDate dateWithTimeIntervalSince1970:time];
        }
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

#pragma mark - clear cache
static NSString *const CYPersistenceCacheLastDeleteCacheDateKey = @"CYPersistenceCacheLastDeleteCacheDateKey";

- (void)startClearCacheAsyncIfNeeded {

    NSDate *currentDate = [NSDate date];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastDeleteDate = [userDefaults objectForKey:CYPersistenceCacheLastDeleteCacheDateKey];

    if (!lastDeleteDate) {

        // if haven't an last delete date, save now
        [userDefaults setObject:[NSDate date]
                         forKey:CYPersistenceCacheLastDeleteCacheDateKey];
        [userDefaults synchronize];
        return;
    }
    // every other 30 days clear
    if (lastDeleteDate
        && [lastDeleteDate isKindOfClass:[NSDate class]]
        && [currentDate timeIntervalSinceDate:lastDeleteDate] > 30l * 24 * 60 * 60) {

        [self clearCacheAsync];
    }
}

- (void)clearCacheAsync {

    NSDate *currentDate = [NSDate date];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        NSFileManager *fileManager = [CYPersistenceCache persistanceSharedManager];
        // get file enumerator from current cache directory
        NSDirectoryEnumerator<NSString *> *enumerator = [fileManager enumeratorAtPath:self.diskCachePath];

        // enumerate all cached file, remove the items that the last read date more than 30 days util now
        NSMutableArray *removeFile = [NSMutableArray array];
        NSString *filePath = nil;
        while ((filePath = enumerator.nextObject)) {

            NSDate *lastReadDate = [self fileLastReadDate:filePath];
            if (lastReadDate
                && [currentDate timeIntervalSinceDate:lastReadDate] > 30l * 24 * 60 * 60) {

                [removeFile addObject:filePath];
            }
        }

        // remove all the items which should delete
        [removeFile enumerateObjectsUsingBlock:^(NSString *path, NSUInteger idx, BOOL * _Nonnull stop) {

            [fileManager removeItemAtPath:path
                                    error:nil];
        }];
    });
}

#pragma mark - static file manager
+ (NSFileManager *)persistanceSharedManager {

    static NSFileManager *fileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {

        fileManager = [[NSFileManager alloc] init];
    });
    return fileManager;
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
