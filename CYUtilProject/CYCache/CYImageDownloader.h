//
//  CYImageDownloader.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/3/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "NSURLRequest+CYImageDownload.h"

@interface CYImageDownloader : NSObject

- (void)startDownloadImageWithUrl:(NSURL *)url
                         progress:(CYImageDownloadProgressBlock)progress
                       completion:(CYImageDownloadCompletion)completion;

#pragma mark - default instance
+ (instancetype)defaultDownloader;

@end
