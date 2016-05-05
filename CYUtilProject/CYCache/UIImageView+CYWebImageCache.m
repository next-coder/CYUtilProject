//
//  UIImageView+CYWebImageCache.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/4/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <objc/runtime.h>

#import "UIImageView+CYWebImageCache.h"

#import "CYWebImageCache.h"

@implementation UIImageView (CYWebImageCache)

@dynamic imageURLString;

static char CYImageViewWebImageCacheURLStringKey;

- (void)setImageURLString:(NSString *)imageURLString {
    
    objc_setAssociatedObject(self, &CYImageViewWebImageCacheURLStringKey, imageURLString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)imageURLString {
    
    return objc_getAssociatedObject(self, &CYImageViewWebImageCacheURLStringKey);
}

- (void)cy_setImageWithURLString:(NSString *)url
                     placeholder:(UIImage *)placeholder {
    
    [self cy_setImageWithURLString:url
                       placeholder:placeholder
                        completion:nil];
}

- (void)cy_setImageWithURLString:(NSString *)url
                     placeholder:(UIImage *)placeholder
                      completion:(void (^)(UIImage *image, NSError *error))completion {
    
    [self cy_setImageWithURL:[NSURL URLWithString:url]
                 placeholder:placeholder
                  completion:completion];
}

- (void)cy_setImageWithURL:(NSURL *)url
               placeholder:(UIImage *)placeholder
                completion:(void (^)(UIImage *image, NSError *error))completion {
    
    self.imageURLString = url.absoluteString;
    if (placeholder) {
        
        self.image = placeholder;
    }
    if (url) {
        
        [[CYWebImageCache defaultCache] imageWithURL:url
                                          completion:^(UIImage *image, NSError *error) {
                                              
                                              if (image
                                                  && [self.imageURLString isEqualToString:url.absoluteString]) {
                                                  
                                                  self.image = image;
                                              }
                                              if (completion) {
                                                  
                                                  completion(image, error);
                                              }
                                          }];
    }
}

@end
