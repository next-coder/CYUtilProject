//
//  UIButton+CYWebImageCache.m
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/5/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <objc/runtime.h>

#import "UIButton+CYWebImageCache.h"
#import "CYWebImageCache.h"

@implementation UIButton (CYWebImageCache)

@dynamic imageURLString;

static char CYButtonWebImageCacheURLStringKey;

- (void)setImageURLString:(NSString *)imageURLString {
    
    objc_setAssociatedObject(self, &CYButtonWebImageCacheURLStringKey, imageURLString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)imageURLString {
    
    return objc_getAssociatedObject(self, &CYButtonWebImageCacheURLStringKey);
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
        
        [self setImage:placeholder forState:UIControlStateNormal];
    }
    if (url) {
        
        [[CYWebImageCache defaultCache] imageWithURL:url
                                          completion:^(UIImage *image, NSError *error) {
                                              
                                              if (image
                                                  && [self.imageURLString isEqualToString:url.absoluteString]) {
                                                  
                                                  [self setImage:image forState:UIControlStateNormal];
                                              }
                                              if (completion) {
                                                  
                                                  completion(image, error);
                                              }
                                          }];
    }
}

@end
