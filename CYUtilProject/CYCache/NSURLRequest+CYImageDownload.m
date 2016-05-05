//
//  NSURLRequest+CYImageDownload.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/4/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <objc/runtime.h>

#import "NSURLRequest+CYImageDownload.h"

@implementation NSURLRequest (CYImageDownload)

@dynamic completion;
@dynamic progressBlock;

static char completionKey;
static char progressBlockKey;

- (void)setCompletion:(CYImageDownloadCompletion)completion {
    
    objc_setAssociatedObject(self, &completionKey, (id)completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CYImageDownloadCompletion)completion {
    
    return (CYImageDownloadCompletion)objc_getAssociatedObject(self, &completionKey);
}

- (void)setProgressBlock:(CYImageDownloadProgressBlock)progressBlock {
    
    objc_setAssociatedObject(self, &progressBlockKey, (id)progressBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CYImageDownloadProgressBlock)progressBlock {
    
    return (CYImageDownloadProgressBlock)objc_getAssociatedObject(self, &progressBlockKey);
}


@end
