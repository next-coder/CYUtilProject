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

- (void)imageWithURL:(NSURL *)url
         roundCorner:(CGFloat)cornerRadius
           imageSize:(CGSize)imageSize
            progress:(CYWebImageCacheProgress)progress
          completion:(CYWebImageCacheCompletion)completion
         persistence:(BOOL)persistence {

    static NSString *const roundCornerLabelPrefix = @"CYRoundCornerImage";
    NSString *roundCornerLabel = [roundCornerLabelPrefix stringByAppendingFormat:@"-%f-%f-%f", imageSize.width, imageSize.height, cornerRadius];

    // 是否有切好的图片缓存
    NSString *roundImageUrl = [url.absoluteString stringByAppendingFormat:@"@@%@", roundCornerLabel];
    UIImage *cachedRoundImage = [_persistenceCache imageForKey:roundImageUrl];
    if (cachedRoundImage) {

        if (completion) {

            dispatch_async(dispatch_get_main_queue(), ^{

                completion(cachedRoundImage, nil);
            });
        }
        return;
    }

    // 是否有缓存原图
    UIImage *cachedOriginImage = [self.persistenceCache imageForKey:url.absoluteString];
    if (cachedOriginImage) {

        UIImage *roundImage = [self pImageFrom:cachedOriginImage
                               withRoundCorner:cornerRadius
                                        inSize:imageSize];
        [self.persistenceCache setImage:roundImage
                                 forKey:roundImageUrl
                                 toDisk:YES];

        if (completion) {

            dispatch_async(dispatch_get_main_queue(), ^{

                completion(cachedRoundImage, nil);
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

                                         UIImage *roundImage = nil;
                                         if (image) {

                                             [self.persistenceCache setImage:image
                                                                      forKey:url.absoluteString
                                                                      toDisk:persistence];

                                             roundImage = [self pImageFrom:image
                                                           withRoundCorner:cornerRadius
                                                                    inSize:imageSize];
                                             [self.persistenceCache setImage:roundImage
                                                                      forKey:roundImageUrl
                                                                      toDisk:YES];
                                         }
                                         if (completion) {

                                             completion(roundImage, error);
                                         }
                                     }];
}



- (UIImage *)pImageFrom:(UIImage *)from
        withRoundCorner:(CGFloat)cornerRadius
                 inSize:(CGSize)size {

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height)
                                cornerRadius:cornerRadius] addClip];

    [from drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
