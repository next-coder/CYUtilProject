//
//  CYWebImageCache.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/3/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CYPersistenceCache.h"
#import "CYImageDownloader.h"

typedef void (^CYWebImageCacheCompletion)(UIImage *image, NSError *error);
typedef void (^CYWebImageCacheProgress)(CGFloat finishedPercent);

@interface CYWebImageCache : NSObject

@property (nonatomic, strong, readonly) CYPersistenceCache *persistenceCache;
@property (nonatomic, strong, readonly) CYImageDownloader *imageDownloader;

- (instancetype)initWithPersistenceCache:(CYPersistenceCache *)persistenceCache
                         imageDownloader:(CYImageDownloader *)imageDownloader;

- (UIImage *)imageCacheWithUrlString:(NSString *)url;

- (void)imageWithURLString:(NSString *)url
                completion:(CYWebImageCacheCompletion)completion;
- (void)imageWithURLString:(NSString *)url
                  progress:(CYWebImageCacheProgress)progress
                completion:(CYWebImageCacheCompletion)completion
               persistence:(BOOL)persistence;

- (void)imageWithURL:(NSURL *)url
          completion:(CYWebImageCacheCompletion)completion;
- (void)imageWithURL:(NSURL *)url
            progress:(CYWebImageCacheProgress)progress
          completion:(CYWebImageCacheCompletion)completion
         persistence:(BOOL)persistence;

- (void)imageWithURL:(NSURL *)url
         roundCorner:(CGFloat)cornerRadius
           imageSize:(CGSize)imageSize
            progress:(CYWebImageCacheProgress)progress
          completion:(CYWebImageCacheCompletion)completion
         persistence:(BOOL)persistence;

#pragma mark - shared instance
+ (instancetype)defaultCache;

@end
