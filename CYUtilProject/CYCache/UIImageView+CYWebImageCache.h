//
//  UIImageView+CYWebImageCache.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/4/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CYWebImageCache)

@property (nonatomic, strong, readonly) NSString *imageURLString;

- (void)cy_setImageWithURLString:(NSString *)url
                     placeholder:(UIImage *)placeholder;

- (void)cy_setImageWithURLString:(NSString *)url
                     placeholder:(UIImage *)placeholder
                      completion:(void (^)(UIImage *image, NSError *error))completion;

- (void)cy_setImageWithURL:(NSURL *)url
               placeholder:(UIImage *)placeholder
                completion:(void (^)(UIImage *image, NSError *error))completion;

@end
