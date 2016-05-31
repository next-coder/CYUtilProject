//
//  CYWebImageCache.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/3/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYWebImageCache.h"

@implementation CYWebImageCache

- (instancetype)initWithPersistenceCache:(CYPersistenceCache *)persistenceCache
                         imageDownloader:(CYImageDownloader *)imageDownloader {
    
    if (self = [super init]) {
        
        _persistenceCache = persistenceCache;
        _imageDownloader = imageDownloader;
    }
    return self;
}

- (UIImage *)imageCacheWithUrlString:(NSString *)url {
    
    return [_persistenceCache imageForKey:url];
}

- (void)imageWithURLString:(NSString *)url
                completion:(CYWebImageCacheCompletion)completion {
    
    [self imageWithURLString:url
                    progress:nil
                  completion:completion
                 persistence:YES];
}

- (void)imageWithURLString:(NSString *)url
                  progress:(CYWebImageCacheProgress)progress
                completion:(CYWebImageCacheCompletion)completion
               persistence:(BOOL)persistence {
    
    [self imageWithURL:[NSURL URLWithString:url]
              progress:progress
            completion:completion
           persistence:persistence];
}

- (void)imageWithURL:(NSURL *)url
          completion:(CYWebImageCacheCompletion)completion {
    
    [self imageWithURL:url
              progress:nil
            completion:completion
           persistence:YES];
}

- (void)imageWithURL:(NSURL *)url
            progress:(CYWebImageCacheProgress)progress
          completion:(CYWebImageCacheCompletion)completion
         persistence:(BOOL)persistence {
    
    UIImage *cachedImage = [_persistenceCache imageForKey:url.absoluteString];
    if (cachedImage) {
        
        if (completion) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(cachedImage, nil);
            });
        }
        return;
    }
    CYImageDownloadProgressBlock downloadProgress = nil;
    if (progress) {
        
        downloadProgress = ^(int64_t bytesWritten,
                             int64_t totalBytesWritten,
                             int64_t totalBytesExpectedToWrite) {
            
            CGFloat percent = (double)totalBytesWritten / totalBytesExpectedToWrite;
            if (progress) {
                
                progress(percent);
            }
        };
    }
    
    [_imageDownloader startDownloadImageWithUrl:url
                                       progress:downloadProgress
                                     completion:^(UIImage *image, NSError *error) {
                                         
                                         if (image) {
                                             
                                             [_persistenceCache setImage:image
                                                                  forKey:url.absoluteString
                                                                  toDisk:persistence];
                                         }
                                         if (completion) {
                                             
                                             completion(image, error);
                                         }
                                     }];
}

#pragma mark - shared instance
+ (instancetype)defaultCache {
    
    static CYWebImageCache *defaultCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        defaultCache = [[CYWebImageCache alloc] initWithPersistenceCache:[CYPersistenceCache defaultCache]
                                                         imageDownloader:[CYImageDownloader defaultDownloader]];
    });
    return defaultCache;
}

@end
