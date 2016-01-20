//
//  CYFullScreenImageView.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 11/4/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYFullScreenImageView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIImage *placeholder;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) NSURL *imageURL;

// default YES
@property (nonatomic, assign) BOOL dismissOnTap;
// default YES
@property (nonatomic, assign) BOOL zoomingEnabled;

- (void)setImage:(UIImage *)image;

- (void)setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder;

#pragma mark - show
- (void)showInView:(UIView *)view
          animated:(BOOL)animated;
- (void)showInKeyWindowAnimated:(BOOL)animated;

#pragma mark - dismiss
- (void)dismissAnimated:(BOOL)animated;

#pragma mark - static show

+ (instancetype)showImage:(UIImage *)image
                   inView:(UIView *)view
                 animated:(BOOL)animated
         dismissAutomatic:(BOOL)dismiss;

@end
