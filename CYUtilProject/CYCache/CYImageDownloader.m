//
//  CYImageDownloader.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/3/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import "CYImageDownloader.h"

@interface CYImageDownloader () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSOperationQueue *downloadTaskQueue;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation CYImageDownloader

- (instancetype)init {
    
    if (self = [super init]) {
        
        _downloadTaskQueue = [[NSOperationQueue alloc] init];
        _downloadTaskQueue.maxConcurrentOperationCount = 5;
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        config.HTTPShouldSetCookies = NO;
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:self
                                            delegateQueue:_downloadTaskQueue];
    }
    return self;
}

- (void)startDownloadImageWithUrl:(NSURL *)url
                         progress:(CYImageDownloadProgressBlock)progress
                       completion:(CYImageDownloadCompletion)completion {
    
    if (url) {
        
        NSURLSessionDownloadTask *task = [_session downloadTaskWithURL:url];
        NSURLRequest *request = task.originalRequest ? : task.currentRequest;
        request.progressBlock = progress;
        request.completion = completion;
        [task resume];
    }
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    NSURLRequest *request = downloadTask.originalRequest ? : downloadTask.currentRequest;
    CYImageDownloadProgressBlock progress = request.progressBlock;
    if (progress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        });
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSURLRequest *request = downloadTask.originalRequest ? : downloadTask.currentRequest;
    CYImageDownloadCompletion completion = request.completion;
    if (completion) {
        
        UIImage *image = nil;
        if (location) {
            
            NSData *imageData = [NSData dataWithContentsOfURL:location];
            if (imageData) {
                
                image = [UIImage imageWithData:imageData];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completion(image, nil);
        });
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
        
        NSURLRequest *request = task.originalRequest ? : task.currentRequest;
        CYImageDownloadCompletion completion = request.completion;
        if (completion) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
    }
}

#pragma mark - default instance
+ (instancetype)defaultDownloader {
    
    static CYImageDownloader *defaultDownloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        defaultDownloader = [[CYImageDownloader alloc] init];
    });
    return defaultDownloader;
}

@end
