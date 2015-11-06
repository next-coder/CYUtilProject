//
//  NSURLRequest+CYImageDownload.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/4/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CYImageDownloadCompletion)(UIImage *image, NSError *error);
typedef void (^CYImageDownloadProgressBlock)(int64_t bytesWritten,
                                             int64_t totalBytesWritten,
                                             int64_t totalBytesExpectedToWrite);

@interface NSURLRequest (CYImageDownload)

@property (nonatomic, copy) CYImageDownloadCompletion completion;
@property (nonatomic, copy) CYImageDownloadProgressBlock progressBlock;

@end
